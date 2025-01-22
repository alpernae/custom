import re
import json
import argparse


def filter_lines(lines, filter_types):
    # Regex patterns
    wildcard_pattern = re.compile(r"^\*\.[a-zA-Z0-9-]+\.[a-zA-Z]+$")
    domain_pattern = re.compile(r"^[a-zA-Z0-9-]+\.[a-zA-Z]+$")
    
    filtered = []
    for line in lines:
        # Remove paths like /xyz or /*
        clean_line = re.sub(r"/.*", "", line.strip())
        
        if "w" in filter_types and wildcard_pattern.match(clean_line):
            filtered.append(clean_line)
        if "d" in filter_types and domain_pattern.match(clean_line):
            filtered.append(clean_line)
    
    return filtered


def process_file(input_file, filter_types):
    # Load data based on file extension
    if input_file.endswith(".json"):
        with open(input_file, "r") as file:
            data = json.load(file)
        # Flatten JSON if it contains lists or nested elements
        if isinstance(data, list):
            lines = [str(item) for item in data]
        elif isinstance(data, dict):
            lines = [str(value) for value in data.values()]
        else:
            raise ValueError("Invalid JSON structure.")
    elif input_file.endswith(".txt"):
        with open(input_file, "r") as file:
            lines = file.readlines()
    else:
        raise ValueError("Unsupported file format. Use .txt or .json.")
    
    # Filter lines based on the specified types
    return filter_lines(lines, filter_types)


def main():
    parser = argparse.ArgumentParser(description="Filter wildcards and domains from a file.")
    parser.add_argument("-w", "--wildcard", action='store_true', help="Include wildcards.")
    parser.add_argument("-d", "--domain", action='store_true', help="Include domains.")
    parser.add_argument("-f", "--file", required=True, help="Input file (txt or json).")
    args = parser.parse_args()

    filter_types = []
    if args.wildcard:
        filter_types.append("w")
    if args.domain:
        filter_types.append("d")
    
    if not filter_types:
        print("Error: At least one filter type (--wildcard or --domain) must be specified.")
        return

    try:
        # Process file and get filtered output
        filtered_output = process_file(args.file, filter_types)
        
        # Determine output file name
        output_file = ""
        if "w" in filter_types and not "d" in filter_types:
            output_file = "wildcards.txt"
            # Remove '*.' from wildcards
            filtered_output = [line.lstrip('*.') for line in filtered_output]
        elif "d" in filter_types and not "w" in filter_types:
            output_file = "domains.txt"
        else:
            parts = []
            if "w" in filter_types:
                parts.append("wildcards")
            if "d" in filter_types:
                parts.append("domains")
            output_file = "_".join(parts) + ".txt"
            if "w" in filter_types:
                filtered_output = [line.lstrip('*.') if line.startswith("*.") else line for line in filtered_output]
        
        # Save the filtered output to a file
        with open(output_file, "w") as file:
            file.write("\n".join(filtered_output))
        
        print(f"Filtered data saved to '{output_file}'.")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
