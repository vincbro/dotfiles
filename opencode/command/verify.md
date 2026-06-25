---
description: Run the project verification pipeline (typecheck, lint, build, tests) and report PASS/FAIL
agent: verifier
subtask: true
---

Run the full verification pipeline for this project and report PASS or FAIL. Use AGENTS.md as the authoritative source for the commands; if it doesn't define a pipeline, detect it from the project manifest. Do not modify any files.