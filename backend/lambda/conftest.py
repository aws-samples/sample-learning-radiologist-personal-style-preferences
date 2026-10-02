"""Pytest configuration for Lambda tests.

Adds the backend/ parent directory to sys.path so that the shared package
(backend/shared/) is importable as `from shared.xxx import ...`.
"""

import sys
from pathlib import Path

# Add backend/ to sys.path for shared module access
backend_dir = str(Path(__file__).parent.parent)
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)
