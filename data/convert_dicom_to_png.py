#!/usr/bin/env python3
"""
Convert DICOM images from MIMIC-CXR dataset to PNG format.

This script processes MIMIC-CXR DICOM files and converts them to PNG format
suitable for display in the radiology report app. It also generates a
mimic_cases.json file with case metadata.

Prerequisites:
1. Download MIMIC-CXR data from PhysioNet (requires credentialed access)
2. Install dependencies: uv add pydicom Pillow

Usage:
    uv run python convert_dicom_to_png.py --input /path/to/mimic-cxr --output /path/to/output

The input directory should contain the MIMIC-CXR structure:
    mimic-cxr/
    ├── files/
    │   ├── p10/
    │   │   ├── p10000032/
    │   │   │   ├── s50414267/
    │   │   │   │   ├── 02aa804e-bde0afdd-112c0b34-7bc16630-4e384014.dcm
    │   │   │   │   └── ...
    │   │   │   └── ...
    │   │   └── ...
    │   └── ...
    └── mimic-cxr-reports/
        └── files/
            └── ...

Output structure:
    output/
    ├── mimic_cases.json         # Case metadata for loading
    └── images/
        ├── p10000032_s50414267_frontal.png
        ├── p10000032_s50414267_lateral.png
        └── ...
"""

import argparse
import json
import os
import sys
from pathlib import Path

try:
    import pydicom
    from PIL import Image
    import numpy as np
except ImportError as e:
    print(f"Missing required dependency: {e}")
    print("Install with: uv add pydicom Pillow numpy")
    sys.exit(1)


def normalize_image(pixel_array: np.ndarray, photometric_interpretation: str = "MONOCHROME2") -> np.ndarray:
    """Normalize DICOM pixel array to 8-bit grayscale.

    Args:
        pixel_array: Raw DICOM pixel data
        photometric_interpretation: DICOM photometric interpretation

    Returns:
        Normalized 8-bit numpy array
    """
    # Handle different bit depths
    arr = pixel_array.astype(float)

    # Normalize to 0-255
    arr_min = arr.min()
    arr_max = arr.max()

    if arr_max > arr_min:
        arr = (arr - arr_min) / (arr_max - arr_min) * 255
    else:
        arr = np.zeros_like(arr)

    # Invert if MONOCHROME1 (white background)
    if photometric_interpretation == "MONOCHROME1":
        arr = 255 - arr

    return arr.astype(np.uint8)


def convert_dicom_to_png(dicom_path: Path, output_path: Path) -> bool:
    """Convert a single DICOM file to PNG.

    Args:
        dicom_path: Path to DICOM file
        output_path: Path for output PNG

    Returns:
        True if conversion succeeded
    """
    try:
        ds = pydicom.dcmread(str(dicom_path))
        pixel_array = ds.pixel_array

        # Get photometric interpretation
        photo_interp = getattr(ds, "PhotometricInterpretation", "MONOCHROME2")

        # Normalize to 8-bit grayscale
        normalized = normalize_image(pixel_array, photo_interp)

        # Create PIL image and save
        img = Image.fromarray(normalized, mode="L")
        img.save(str(output_path), "PNG")

        return True

    except Exception as e:
        print(f"  Error converting {dicom_path.name}: {e}")
        return False


def get_view_type(dicom_path: Path) -> str:
    """Determine if image is frontal or lateral view.

    Args:
        dicom_path: Path to DICOM file

    Returns:
        'frontal' or 'lateral'
    """
    try:
        ds = pydicom.dcmread(str(dicom_path), stop_before_pixels=True)
        view_position = getattr(ds, "ViewPosition", "").upper()

        if view_position in ["PA", "AP"]:
            return "frontal"
        elif view_position in ["LL", "LATERAL"]:
            return "lateral"

        # Fallback: check filename
        filename = dicom_path.name.lower()
        if "lateral" in filename or "ll" in filename:
            return "lateral"

        return "frontal"  # Default to frontal

    except Exception:
        return "frontal"


def parse_report(report_path: Path) -> tuple[str, str]:
    """Parse MIMIC-CXR report file to extract findings and impression.

    Args:
        report_path: Path to report text file

    Returns:
        Tuple of (findings, impression)
    """
    try:
        with open(report_path, "r") as f:
            content = f.read()

        # Parse sections
        findings = ""
        impression = ""

        # Look for FINDINGS section
        if "FINDINGS:" in content.upper():
            idx = content.upper().index("FINDINGS:")
            end_idx = len(content)

            # Find next section
            for section in ["IMPRESSION:", "CONCLUSION:", "RECOMMENDATION:"]:
                if section in content.upper()[idx:]:
                    section_idx = content.upper()[idx:].index(section)
                    if section_idx < end_idx - idx:
                        end_idx = idx + section_idx

            findings = content[idx + 9:end_idx].strip()

        # Look for IMPRESSION section
        for section in ["IMPRESSION:", "CONCLUSION:"]:
            if section in content.upper():
                idx = content.upper().index(section)
                end_idx = len(content)

                # Find next section
                for next_section in ["RECOMMENDATION:", "NOTIFICATION:"]:
                    if next_section in content.upper()[idx:]:
                        next_idx = content.upper()[idx:].index(next_section)
                        if next_idx < end_idx - idx:
                            end_idx = idx + next_idx

                impression = content[idx + len(section):end_idx].strip()
                break

        return findings, impression

    except Exception as e:
        print(f"  Error parsing report {report_path}: {e}")
        return "", ""


def process_mimic_cxr(input_dir: Path, output_dir: Path, max_cases: int = 100) -> dict:
    """Process MIMIC-CXR dataset and generate PNG images.

    Args:
        input_dir: Path to MIMIC-CXR root directory
        output_dir: Path to output directory
        max_cases: Maximum number of cases to process

    Returns:
        Dict with case metadata for mimic_cases.json
    """
    files_dir = input_dir / "files"
    reports_dir = input_dir / "mimic-cxr-reports" / "files"

    if not files_dir.exists():
        print(f"Error: DICOM files directory not found: {files_dir}")
        print("Expected MIMIC-CXR directory structure with files/ subdirectory")
        return {"cases": []}

    # Create output directories
    images_dir = output_dir / "images"
    images_dir.mkdir(parents=True, exist_ok=True)

    cases = []
    processed = 0

    print(f"Processing MIMIC-CXR from {input_dir}")
    print(f"Output directory: {output_dir}")
    print(f"Max cases: {max_cases}")
    print("-" * 50)

    # Walk through patient directories
    for p_group in sorted(files_dir.iterdir()):
        if not p_group.is_dir() or not p_group.name.startswith("p"):
            continue

        for patient_dir in sorted(p_group.iterdir()):
            if not patient_dir.is_dir():
                continue

            patient_id = patient_dir.name

            for study_dir in sorted(patient_dir.iterdir()):
                if not study_dir.is_dir():
                    continue

                study_id = study_dir.name

                if processed >= max_cases:
                    break

                # Find DICOM files
                dicom_files = list(study_dir.glob("*.dcm"))
                if not dicom_files:
                    continue

                # Find corresponding report
                report_path = None
                for possible_path in [
                    reports_dir / p_group.name / patient_id / f"{study_id}.txt",
                    reports_dir / patient_id / f"{study_id}.txt",
                ]:
                    if possible_path.exists():
                        report_path = possible_path
                        break

                if not report_path:
                    continue

                # Parse report
                findings, impression = parse_report(report_path)
                if not findings:
                    continue

                # Convert DICOM files to PNG
                case_id = f"{patient_id}_{study_id}"
                image_keys = []

                for dicom_path in dicom_files:
                    view_type = get_view_type(dicom_path)
                    output_filename = f"{case_id}_{view_type}.png"
                    output_path = images_dir / output_filename

                    if convert_dicom_to_png(dicom_path, output_path):
                        image_keys.append(f"images/{output_filename}")

                if not image_keys:
                    continue

                # Create case entry
                case = {
                    "case_id": case_id,
                    "findings": findings,
                    "reference_impression": impression,
                    "s3_image_keys": image_keys,
                }
                cases.append(case)
                processed += 1

                print(f"  Processed: {case_id} ({len(image_keys)} images)")

            if processed >= max_cases:
                break

        if processed >= max_cases:
            break

    print("-" * 50)
    print(f"Processed {processed} cases")

    return {"cases": cases}


def main():
    parser = argparse.ArgumentParser(
        description="Convert MIMIC-CXR DICOM images to PNG format",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Convert 100 cases (default)
  uv run python convert_dicom_to_png.py --input /path/to/mimic-cxr --output /path/to/output

  # Convert more cases
  uv run python convert_dicom_to_png.py --input /path/to/mimic-cxr --output /path/to/output --max-cases 500

After conversion, set MIMIC_BUCKET_PATH and upload to S3:
  aws s3 sync /path/to/output "$MIMIC_BUCKET_PATH"
        """
    )
    parser.add_argument(
        "--input",
        required=True,
        type=Path,
        help="Path to MIMIC-CXR root directory"
    )
    parser.add_argument(
        "--output",
        required=True,
        type=Path,
        help="Path to output directory"
    )
    parser.add_argument(
        "--max-cases",
        type=int,
        default=100,
        help="Maximum number of cases to process (default: 100)"
    )
    args = parser.parse_args()

    # Process MIMIC-CXR
    result = process_mimic_cxr(args.input, args.output, args.max_cases)

    # Write metadata file
    output_file = args.output / "mimic_cases.json"
    with open(output_file, "w") as f:
        json.dump(result, f, indent=2)

    print(f"\nWrote metadata to {output_file}")
    print(f"Total cases: {len(result['cases'])}")
    print("\nNext steps:")
    print(f"  1. Upload to S3: aws s3 sync {args.output} \"$MIMIC_BUCKET_PATH\"")
    print("  2. Configure bucket policy (see data/README.md)")
    print("  3. Load cases: uv run python load_data.py --data-source mimic --mimic-bucket your-bucket/mimic-cxr --clear")


if __name__ == "__main__":
    main()
