import argparse
import sys
import json


def parse_log(filepath):
    result = {"errors": 0, "warnings": 0, "error_lines": [], "warning_lines": []}

    with open(filepath) as f:
        for line in f:
            if "ERROR" in line:
                result["errors"] += 1
                result["error_lines"].append(line.strip())
            if "WARNING" in line:
                result["warnings"] += 1
                result["warning_lines"].append(line.strip())

    return result


# Parse arguments, run log parsing, and print results
def main():
    parser = argparse.ArgumentParser(description="Parse log files for warnings and errors")
    parser.add_argument("logfile", help="Path to the log file")
    parser.add_argument("--level", help="Filter by severity (ERROR or WARNING)")
    parser.add_argument("--json", action="store_true", help="Output results in JSON format")
    args = parser.parse_args()

    try:
        result = parse_log(args.logfile)

        if args.json:
            print(json.dumps(result))

        else:
            print(f"\nRESULT: {result['errors']} errors, {result['warnings']} warnings found")
            if args.level != "WARNING":
                print("\n---Errors---")
                for line in result["error_lines"]:
                    print(line)

            if args.level != "ERROR":
                print("\n---Warnings---")
                for line in result["warning_lines"]:
                    print(line)

        sys.exit(1 if result["errors"] > 0 else 0)

    except FileNotFoundError:
        print("Error: log file not found.")
        sys.exit(1)


if __name__ == "__main__":
    main()

