"""
Shared input validation limits.

Single source of truth imported by both Lambda (backend/lambda/utils.py, models.py)
and Agent (backend/agent/config.py) deployments.
"""

MAX_FINDINGS_LENGTH = 50000  # ~10k tokens
MAX_IMPRESSION_LENGTH = 10000  # ~2k tokens
MAX_CASE_ID_LENGTH = 64
