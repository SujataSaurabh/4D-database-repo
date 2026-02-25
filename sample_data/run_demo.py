"""
Demo runner: executes the Python analysis scripts against sample CSV data.
Patches hardcoded file paths to use local sample data instead.
"""
import os
import sys
import importlib.util
import tempfile

SAMPLE_DIR = os.path.dirname(os.path.abspath(__file__))
PYTHON_DIR = os.path.join(os.path.dirname(SAMPLE_DIR), "python")
INPUT_CSV = os.path.join(SAMPLE_DIR, "proposal_beamlines_summary_2.csv")

def patch_and_run(script_name, input_path_overrides, output_path_overrides):
    """Read a script, patch hardcoded paths, and execute it."""
    script_path = os.path.join(PYTHON_DIR, script_name)
    with open(script_path, "r") as f:
        code = f.read()

    for old, new in input_path_overrides.items():
        code = code.replace(old, new)
    for old, new in output_path_overrides.items():
        code = code.replace(old, new)

    print(f"\n{'='*60}")
    print(f"Running: {script_name}")
    print(f"{'='*60}")
    try:
        exec(compile(code, script_path, "exec"), {"__name__": "__main__"})
        print(f"[OK] {script_name} completed successfully")
        return True
    except Exception as e:
        print(f"[ERROR] {script_name} failed: {e}")
        return False


def main():
    results = {}
    output_dir = tempfile.mkdtemp(prefix="als_demo_")
    print(f"Output directory: {output_dir}")

    # Script 1: GetBeamlinesProposalSummary.py
    results["GetBeamlinesProposalSummary.py"] = patch_and_run(
        "GetBeamlinesProposalSummary.py",
        {"/Users/sujatagoswami/Documents/ALS_DATA/proposal_beamlines_summary_2.csv": INPUT_CSV},
        {"/Users/sujatagoswami/Documents/ALS_DATA/people_with_first_funding_subsequent_funding_updated_1.csv":
         os.path.join(output_dir, "people_with_first_funding.csv")},
    )

    # Script 2: GetFirstTimeSuccessfulProposals.py
    results["GetFirstTimeSuccessfulProposals.py"] = patch_and_run(
        "GetFirstTimeSuccessfulProposals.py",
        {"/Users/sujatagoswami/Documents/ALS_DATA/proposal_beamlines_summary_2.csv": INPUT_CSV},
        {},
    )

    # Script 3: PIsWithUnsuccessfulProposals.py
    results["PIsWithUnsuccessfulProposals.py"] = patch_and_run(
        "PIsWithUnsuccessfulProposals.py",
        {"/Users/sujatagoswami/Documents/ALS_DATA/proposal_beamlines_summary_2.csv": INPUT_CSV},
        {"/Users/sujatagoswami/Documents/ALS_DATA/pis_never_got_beamtime.csv":
         os.path.join(output_dir, "pis_never_got_beamtime.csv")},
    )

    # Script 4: ProposalCountPerYear.py - needs the output of script 1
    intermediate_csv = os.path.join(output_dir, "people_with_first_funding.csv")
    if os.path.exists(intermediate_csv):
        results["ProposalCountPerYear.py"] = patch_and_run(
            "ProposalCountPerYear.py",
            {"/Users/sujatagoswami/Documents/ALS_DATA/people_with_first_funding_subsequent_funding_updated_1.csv":
             intermediate_csv},
            {"/Users/sujatagoswami/Documents/ALS_DATA/pis_per_year.csv":
             os.path.join(output_dir, "pis_per_year.csv")},
        )
    else:
        print("\nSkipping ProposalCountPerYear.py (depends on output of GetBeamlinesProposalSummary.py)")
        results["ProposalCountPerYear.py"] = False

    print(f"\n{'='*60}")
    print("RESULTS SUMMARY")
    print(f"{'='*60}")
    for name, ok in results.items():
        status = "PASS" if ok else "FAIL"
        print(f"  [{status}] {name}")

    all_pass = all(results.values())
    print(f"\nOverall: {'ALL PASSED' if all_pass else 'SOME FAILED'}")
    print(f"Output files in: {output_dir}")

    for f in os.listdir(output_dir):
        fpath = os.path.join(output_dir, f)
        size = os.path.getsize(fpath)
        print(f"  {f} ({size} bytes)")

    return 0 if all_pass else 1


if __name__ == "__main__":
    sys.exit(main())
