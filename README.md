# qa_automation
A collection of QA automation projects showcasing skills in test automation frameworks, API testing, and performance testing.


## Supported environment

Primary supported runtime: **Linux x86_64 (amd64)** (VPS / CI)

⚠️ Apple Silicon (arm64, Mac M1/M2/M3):
- Not officially supported for UI (Selenium/Chromium) containers.
- If you must run locally, use emulation:
  `docker compose --profile ci up` (or set `platform: linux/amd64` in compose).
- Expect slower builds and possible browser/driver dependency issues.