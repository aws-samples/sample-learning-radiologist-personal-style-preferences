#!/usr/bin/env python3
"""
Download diverse MIMIC-CXR cases from S3.

Selects 150 varied cases using CheXpert diagnostic labels to ensure diversity,
downloads report text files, parses FINDINGS and IMPRESSION sections,
and creates JSON output compatible with load_data.py.

Usage:
    export MIMIC_SOURCE_S3_URI=<S3_URI>
    uv run python download_mimic.py                    # Download 150 cases
    uv run python download_mimic.py --count 50         # Download 50 cases
    uv run python download_mimic.py --dry-run          # Preview selection without downloading
    uv run python download_mimic.py --include-images   # Also download DICOM images (large!)
"""

import argparse
import csv
import json
import os
import random
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

S3_BUCKET = os.environ.get("MIMIC_SOURCE_S3_URI", "").rstrip("/")
PATIENT_PREFIX = "p11"  # Use p11 patient subset
CHEXPERT_KEY = "mimic-cxr-2.0.0-chexpert.csv"
OUTPUT_DIR = Path(__file__).parent
OUTPUT_FILE = OUTPUT_DIR / "mimic_cases.json"
IMAGES_DIR = OUTPUT_DIR / "mimic_images"

# Diagnostic labels in CheXpert
LABELS = [
    'Atelectasis', 'Cardiomegaly', 'Consolidation', 'Edema',
    'Enlarged Cardiomediastinum', 'Fracture', 'Lung Lesion',
    'Lung Opacity', 'No Finding', 'Pleural Effusion',
    'Pleural Other', 'Pneumonia', 'Pneumothorax', 'Support Devices'
]

# Target distribution for 150 cases (proportional to prevalence with minimum representation)
TARGET_DISTRIBUTION = {
    'No Finding': 25,              # Normal cases
    'Support Devices': 20,         # Lines, tubes, devices
    'Pleural Effusion': 18,        # Fluid in pleural space
    'Lung Opacity': 15,            # General opacity
    'Cardiomegaly': 15,            # Enlarged heart
    'Atelectasis': 15,             # Collapsed lung
    'Edema': 12,                   # Pulmonary edema
    'Pneumonia': 10,               # Infection
    'Pneumothorax': 8,             # Air in pleural space
    'Consolidation': 6,            # Dense opacity
    'Enlarged Cardiomediastinum': 3,
    'Lung Lesion': 3,
    'Fracture': 2,
    'Pleural Other': 2,
}


def download_chexpert(local_path: Path) -> Path:
    """Download CheXpert labels CSV from S3."""
    if local_path.exists():
        print(f"Using cached CheXpert file: {local_path}")
        return local_path

    print(f"Downloading CheXpert labels from S3...")
    s3_path = f"{S3_BUCKET}/{CHEXPERT_KEY}"
    result = subprocess.run(
        ["aws", "s3", "cp", s3_path, str(local_path)],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"Error downloading CheXpert: {result.stderr}")
        sys.exit(1)
    return local_path


def load_chexpert(csv_path: Path) -> dict:
    """Load CheXpert labels and index by (subject_id, study_id)."""
    studies = {}
    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            subject_id = row['subject_id']
            study_id = row['study_id']

            # Filter for p11 patients only
            if not subject_id.startswith('11'):
                continue

            # Parse labels
            positive_labels = []
            uncertain_labels = []
            for label in LABELS:
                val = row.get(label, '')
                if val == '1.0':
                    positive_labels.append(label)
                elif val == '-1.0':
                    uncertain_labels.append(label)

            studies[(subject_id, study_id)] = {
                'subject_id': subject_id,
                'study_id': study_id,
                'positive': positive_labels,
                'uncertain': uncertain_labels,
            }

    return studies


def select_diverse_cases(studies: dict, target_count: int, oversample_factor: float = 3.0) -> list:
    """Select diverse cases based on diagnostic distribution.

    Args:
        studies: Dictionary of all available studies
        target_count: Desired final number of cases
        oversample_factor: How many extra cases to select to account for skips
    """
    # Group studies by their primary (first positive) label
    by_label = defaultdict(list)
    for key, study in studies.items():
        if study['positive']:
            primary_label = study['positive'][0]  # Use first label as primary
            by_label[primary_label].append(study)
        elif not study['positive'] and not study['uncertain']:
            # Truly normal - no positive or uncertain findings
            by_label['No Finding'].append(study)

    # Scale target distribution to requested count, with oversampling
    scale = (target_count * oversample_factor) / 150
    scaled_targets = {k: max(1, int(v * scale)) for k, v in TARGET_DISTRIBUTION.items()}

    # Select cases proportionally
    selected = []
    random.seed(42)  # Reproducible selection

    for label, target in scaled_targets.items():
        available = by_label.get(label, [])
        if not available:
            print(f"  Warning: No cases available for {label}")
            continue

        # Randomly sample up to target count
        sample_size = min(target, len(available))
        sampled = random.sample(available, sample_size)
        selected.extend(sampled)
        print(f"  {label}: selected {sample_size}/{target} (available: {len(available)})")

    # Remove duplicates (a case might be selected for multiple labels)
    seen = set()
    unique = []
    for s in selected:
        key = (s['subject_id'], s['study_id'])
        if key not in seen:
            seen.add(key)
            unique.append(s)

    print(f"\nTotal unique cases selected for download attempt: {len(unique)}")
    print(f"(Oversampled {oversample_factor}x to account for reports missing sections)")
    return unique


def download_report(subject_id: str, study_id: str) -> str | None:
    """Download a single report from S3."""
    s3_path = f"{S3_BUCKET}/{PATIENT_PREFIX}/p{subject_id}/s{study_id}.txt"
    result = subprocess.run(
        ["aws", "s3", "cp", s3_path, "-"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        return None
    return result.stdout


def parse_report(text: str) -> dict:
    """Parse FINDINGS and IMPRESSION sections from report text."""
    # Normalize whitespace but preserve some structure
    text = re.sub(r'[ \t]+', ' ', text)  # Collapse horizontal whitespace
    text = re.sub(r'\n\s*\n', '\n\n', text)  # Collapse multiple newlines
    text = text.strip()

    # Try multiple patterns for FINDINGS section
    findings = ""
    findings_patterns = [
        r'FINDINGS?:\s*(.*?)(?=IMPRESSION|CONCLUSION|RECOMMENDATION|$)',
        r'FINDING\(S\):\s*(.*?)(?=IMPRESSION|CONCLUSION|RECOMMENDATION|$)',
    ]
    for pattern in findings_patterns:
        findings_match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if findings_match:
            findings = findings_match.group(1).strip()
            break

    # Try multiple patterns for IMPRESSION section
    impression = ""
    impression_patterns = [
        r'IMPRESSION:\s*(.*?)(?=RECOMMENDATION|NOTIFICATION|$)',
        r'IMPRESSIONS?:\s*(.*?)(?=RECOMMENDATION|NOTIFICATION|$)',
        r'CONCLUSION:\s*(.*?)(?=RECOMMENDATION|NOTIFICATION|$)',
    ]
    for pattern in impression_patterns:
        impression_match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if impression_match:
            impression = impression_match.group(1).strip()
            break

    # Clean up extracted text
    findings = re.sub(r'\s+', ' ', findings).strip()
    impression = re.sub(r'\s+', ' ', impression).strip()

    return {
        'findings': findings,
        'impression': impression,
        'raw_text': text
    }


def list_study_images(subject_id: str, study_id: str) -> list:
    """List DICOM images for a study."""
    s3_path = f"{S3_BUCKET}/{PATIENT_PREFIX}/p{subject_id}/s{study_id}/"
    result = subprocess.run(
        ["aws", "s3", "ls", s3_path],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        return []

    images = []
    for line in result.stdout.strip().split('\n'):
        if line.endswith('.dcm'):
            # Parse: "2020-06-29 19:30:02   15551566 filename.dcm"
            parts = line.split()
            if len(parts) >= 4:
                filename = parts[-1]
                images.append({
                    's3_key': f"{PATIENT_PREFIX}/p{subject_id}/s{study_id}/{filename}",
                    'filename': filename
                })

    return images


def download_images(subject_id: str, study_id: str, images: list, output_dir: Path) -> list:
    """Download DICOM images for a study."""
    study_dir = output_dir / f"p{subject_id}" / f"s{study_id}"
    study_dir.mkdir(parents=True, exist_ok=True)

    downloaded = []
    for img in images:
        s3_path = f"{S3_BUCKET}/{img['s3_key']}"
        local_path = study_dir / img['filename']

        result = subprocess.run(
            ["aws", "s3", "cp", s3_path, str(local_path)],
            capture_output=True, text=True
        )
        if result.returncode == 0:
            downloaded.append(str(local_path.relative_to(output_dir.parent)))

    return downloaded


def main():
    parser = argparse.ArgumentParser(description='Download diverse MIMIC-CXR cases')
    parser.add_argument('--count', type=int, default=150,
                        help='Number of cases to download (default: 150)')
    parser.add_argument('--dry-run', action='store_true',
                        help='Preview selection without downloading')
    parser.add_argument('--include-images', action='store_true',
                        help='Also download DICOM images (warning: large files!)')
    parser.add_argument('--output', type=str, default=str(OUTPUT_FILE),
                        help=f'Output JSON file (default: {OUTPUT_FILE})')
    args = parser.parse_args()
    if not S3_BUCKET:
        parser.error("Set MIMIC_SOURCE_S3_URI to the authorized dataset location")

    print("=" * 60)
    print("MIMIC-CXR Data Downloader")
    print("=" * 60)

    # Step 1: Download/load CheXpert labels
    chexpert_path = Path("/tmp/chexpert.csv")
    download_chexpert(chexpert_path)

    print("\nLoading CheXpert labels...")
    studies = load_chexpert(chexpert_path)
    print(f"Loaded {len(studies)} studies from {PATIENT_PREFIX} patients")

    # Step 2: Select diverse cases
    print(f"\nSelecting {args.count} diverse cases...")
    selected = select_diverse_cases(studies, args.count)

    if args.dry_run:
        print("\n[DRY RUN] Would download the following cases:")
        for i, s in enumerate(selected[:10], 1):
            print(f"  {i}. p{s['subject_id']}/s{s['study_id']} - {', '.join(s['positive']) or 'Normal'}")
        if len(selected) > 10:
            print(f"  ... and {len(selected) - 10} more")
        return

    # Step 3: Download reports and parse
    print(f"\nDownloading reports (target: {args.count} cases)...")
    cases = []
    failed = 0
    skipped_empty = 0

    for i, study in enumerate(selected, 1):
        # Stop once we have enough cases
        if len(cases) >= args.count:
            print(f"\n  Reached target of {args.count} cases, stopping early.")
            break

        subject_id = study['subject_id']
        study_id = study['study_id']

        # Download report
        report_text = download_report(subject_id, study_id)
        if not report_text:
            print(f"  [{i}/{len(selected)}] Failed: p{subject_id}/s{study_id}")
            failed += 1
            continue

        # Parse report
        parsed = parse_report(report_text)

        # Skip cases with empty findings or impressions
        if not parsed['findings'] or not parsed['impression']:
            skipped_empty += 1
            if skipped_empty <= 10:  # Only show first 10 skips
                print(f"  [{i}/{len(selected)}] Skipped (missing sections): p{subject_id}/s{study_id}")
            elif skipped_empty == 11:
                print(f"  (suppressing further skip messages...)")
            continue

        # List images
        images = list_study_images(subject_id, study_id)

        # Optionally download images
        local_images = []
        if args.include_images and images:
            local_images = download_images(subject_id, study_id, images, IMAGES_DIR)

        case = {
            'case_id': f"MIMIC_{subject_id}_{study_id}",
            'findings': parsed['findings'],
            'reference_impression': parsed['impression'],
            'source': {
                'dataset': 'MIMIC-CXR',
                'subject_id': subject_id,
                'study_id': study_id,
                'labels': study['positive'],
                's3_report_key': f"{PATIENT_PREFIX}/p{subject_id}/s{study_id}.txt",
                's3_image_keys': [img['s3_key'] for img in images],
            }
        }

        if local_images:
            case['source']['local_images'] = local_images

        cases.append(case)

        if len(cases) % 20 == 0:
            print(f"  Progress: {len(cases)}/{args.count} cases downloaded...")

    # Step 4: Save output
    output_path = Path(args.output)
    output = {'cases': cases}

    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)

    print("\n" + "=" * 60)
    print(f"COMPLETE: Downloaded {len(cases)} cases")
    print(f"Download failures: {failed}")
    print(f"Skipped (missing FINDINGS/IMPRESSION): {skipped_empty}")
    print(f"Output: {output_path}")
    print("=" * 60)

    # Print diagnostic distribution of downloaded cases
    print("\nDiagnostic distribution of downloaded cases:")
    label_counts = defaultdict(int)
    for case in cases:
        for label in case['source']['labels']:
            label_counts[label] += 1
        if not case['source']['labels']:
            label_counts['No Finding'] += 1

    for label, count in sorted(label_counts.items(), key=lambda x: -x[1]):
        print(f"  {label}: {count}")


if __name__ == '__main__':
    main()
