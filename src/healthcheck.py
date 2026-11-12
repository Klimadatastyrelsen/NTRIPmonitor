"""Liveness probe: exits non-zero unless the main process has confirmed all children alive
within MAX_AGE seconds (argv[1], default 120). See childWatcher in ingestion.py."""

import os
import sys
import time

path = os.path.join(os.getenv("HEARTBEAT_DIR", "/tmp"), "ntripmonitor-alive")
maxAge = float(sys.argv[1]) if len(sys.argv) > 1 else 120
try:
    age = time.time() - os.path.getmtime(path)
except OSError:
    sys.exit(f"{path} missing")
if age > maxAge:
    sys.exit(f"{path} is {age:.0f} s old")
