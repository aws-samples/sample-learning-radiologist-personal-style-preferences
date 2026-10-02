# Data Management

> **Related Documentation:**
> - [Deployment Guide](../docs/deployment-guide.md) - Full deployment instructions
> - [Architecture](../docs/architecture.md) - System design overview

This directory contains scripts and configuration for managing radiology case data.

## Data Sources

The app supports two data sources:

| Source | Description | Images | Setup Required |
|--------|-------------|--------|----------------|
| **Synthetic** (default) | 25 synthetic cases with placeholder images | Bundled placeholder | None - works out of the box |
| **MIMIC** | Real MIMIC-CXR chest X-rays | From your S3 bucket | Yes - see setup below |

## Quick Start (Synthetic Data)

Synthetic data works immediately with no setup:

```bash
cd data
uv run python load_data.py --clear
```

This loads 25 synthetic radiology cases with placeholder X-ray images.

## MIMIC-CXR Setup

To use real MIMIC-CXR data, you need to:

1. Obtain PhysioNet credentialed access
2. Download MIMIC-CXR data
3. Convert DICOM images to PNG
4. Upload to your S3 bucket
5. Configure bucket policy
6. Switch data source in the app

### Prerequisites

- **PhysioNet account** with credentialed access to MIMIC-CXR
- **AWS account** with an S3 bucket
- **Python 3.12+** with uv

### Step 1: Download MIMIC-CXR

After obtaining PhysioNet access, download the MIMIC-CXR dataset:

```bash
# Using PhysioNet download tools
wget -r -N -c -np https://physionet.org/files/mimic-cxr/2.0.0/
```

You need:
- DICOM images from `files/` directory
- Report text files from `mimic-cxr-reports/files/`

### Step 2: Convert DICOM to PNG

Install dependencies and run the conversion script:

```bash
cd data
uv sync  # Installs pydicom, Pillow, numpy

# Convert up to 100 cases (adjust --max-cases as needed)
uv run python convert_dicom_to_png.py \
    --input /path/to/mimic-cxr \
    --output /path/to/output \
    --max-cases 100
```

This creates:
- `output/mimic_cases.json` - Case metadata
- `output/images/*.png` - Converted PNG images

### Step 3: Upload to S3

Set the destination URI for your approved bucket and upload the converted data:

```bash
export MIMIC_BUCKET_PATH=<S3_DESTINATION_URI>
aws s3 sync /path/to/output "$MIMIC_BUCKET_PATH"
```

### Step 4: Configure Bucket Access

Include `<BUCKET_NAME>/<PREFIX>` in `MIMIC_BUCKET_PATHS` when deploying `ApiStack`. For cross-account buckets, also add a bucket policy that grants the Lambda execution role `s3:ListBucket` on `<BUCKET_ARN>` and `s3:GetObject` on `<OBJECT_PREFIX_ARN>`. Scope any `s3:prefix` condition to the same prefix.

### Step 5: Load MIMIC Cases

Load the cases into DynamoDB:

```bash
cd data
uv run python load_data.py \
    --data-source mimic \
    --mimic-bucket <BUCKET_NAME>/<PREFIX> \
    --clear
```

### Step 6: Configure App

In the app's Settings tab:
1. Go to **Data Source** section
2. Select **MIMIC-CXR**
3. Enter the same allowlisted bucket path
4. Confirm the data reset

The app will display real chest X-rays from your S3 bucket.

## Switching Data Sources

You can switch between Synthetic and MIMIC at any time through the app's Settings.

**Warning**: Switching data sources will:
- Delete all your cases
- Delete all learned preferences
- Delete all edit history
- Reload cases from the new source

This action cannot be undone.

## Scripts Reference

### load_data.py

Load cases into DynamoDB:

```bash
# Synthetic data (default)
uv run python load_data.py [--clear]

# MIMIC data
uv run python load_data.py --data-source mimic --mimic-bucket BUCKET [--clear]

# Options
--user-id       User ID (default: test-user@example.com)
--clear         Clear all tables before loading
--clear-only    Only clear tables, don't load data
--clear-all-users  Clear data for ALL users (dangerous!)
```

### convert_dicom_to_png.py

Convert MIMIC-CXR DICOM files to PNG:

```bash
uv run python convert_dicom_to_png.py \
    --input /path/to/mimic-cxr \
    --output /path/to/output \
    --max-cases 100
```

## Troubleshooting

### "Cannot access MIMIC bucket" error

1. Check the bucket name is correct
2. Verify the bucket policy allows Lambda access
3. Ensure the Lambda role has S3 permissions (check CDK deployment)

### "mimic_cases.json not found"

The metadata file must exist at the root of the configured MIMIC path in S3.

### Images not loading

1. Check presigned URL hasn't expired (15 minute expiry)
2. Refresh the case detail to get new URLs
3. Verify PNG files exist in S3 at the expected paths

### Placeholder image shows for MIMIC data

This happens when:
- The case doesn't have `s3_image_keys` in the database
- You need to reload the cases with `load_data.py`

## File Structure

```
data/
├── README.md                    # This file
├── pyproject.toml               # Python dependencies
├── load_data.py                 # Load cases into DynamoDB
├── convert_dicom_to_png.py      # Convert DICOM to PNG
└── synthetic_cases.json         # Synthetic case data
```
