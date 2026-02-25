# AGENTS.md

## Cursor Cloud specific instructions

### Repository overview

This repository contains **4D Database language methods** (`.4dm` files) and **Python data analysis scripts** (`python/`). The 4D methods are for the ALS User Services (ALSHUB) portal at Lawrence Berkeley National Laboratory and require proprietary 4D Server software to run. Only the Python scripts can be executed in a standard development environment.

### Python scripts

- **Dependency**: `pandas` (the only external library used by all 4 scripts).
- The scripts in `python/` have **hardcoded file paths** pointing to `/Users/sujatagoswami/Documents/ALS_DATA/`. To run them, either:
  - Use `sample_data/run_demo.py` which patches paths automatically and runs all 4 scripts against sample CSV data.
  - Manually override the paths before running individual scripts.
- Scripts read/write CSV files; they are standalone data analysis utilities with no web server or service component.

### Running the Python scripts

```bash
python3 sample_data/run_demo.py
```

### Linting

```bash
flake8 python/
```

The existing codebase has ~113 flake8 warnings (mostly E501 line length and whitespace). These are pre-existing.

### 4D Database methods

The `.4dm` files at the repo root cannot be executed without commercial 4D Server software. They are stored-procedure source files for the ALS User Services database. No automated tests or build system exists for these files.

### No automated test suite

This repository has no test framework or CI/CD configuration. Validation of the Python scripts is done by running `sample_data/run_demo.py`.
