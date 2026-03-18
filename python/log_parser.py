import argparse           # Handles user input after script name in command line

parser = argparse.ArgumentParser(description="Parse log files for warnings and errors")  # description used when user runs script with --help
parser.add_argument("logfile", help="Path to the log file")                              # specifies argument script expects
args = parser.parse_args()                                                               # store the parsed arguments in a variable 


errors = 0
warnings = 0
error_lines = []
warning_lines = []

try:
    with open(args.logfile) as f:
        for line in f:
            if "ERROR" in line:
                errors += 1
                error_lines.append(line)
            if "WARNING" in line:
                warnings += 1
                warning_lines.append(line)

    print(f"Errors: {errors}")
    print(f"Warnings: {warnings}")
    print("\n---Errors---")
    for line in error_lines:
        print(line.strip())

    print("\n---Warnings---")
    for line in warning_lines:
        print(line.strip())  

except FileNotFoundError:
    print("Error: log file not found.")
