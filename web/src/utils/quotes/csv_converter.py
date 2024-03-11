import csv
import json
import sys
import re

def snake_case(s):
    """Converts a string to snake_case."""
    return re.sub(r'\s+', '_', re.sub(r'(?<!^)(?=[A-Z])', '_', s)).lower()

def auto_detect_id_column(fieldnames):
    """Attempts to auto-detect the id column from given fieldnames."""
    for field in fieldnames:
        lower_field = field.lower()
        if lower_field == 'id' or lower_field.endswith('_id'):
            return field
    return None

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <input_file.csv>")
        sys.exit(1)

    input_filename = sys.argv[1]
    base_filename = input_filename.rsplit('.', 1)[0]
    
    with open(input_filename, newline='', encoding='utf-8-sig') as csvfile:
        reader = csv.DictReader(csvfile)
        fieldnames = [snake_case(field) for field in reader.fieldnames]
        
        id_column = auto_detect_id_column(fieldnames)
        if id_column is None:
            print("Available fields:", ', '.join(fieldnames))
            id_column = snake_case(input("Enter the field name to use as ID: ").strip())
        
        print(f"Using '{id_column}' as the ID column.")
        
        print("Available fields for translation:", ', '.join(fieldnames))
        field_to_translate = snake_case(input("Enter the field name to translate: ").strip())
        
        if field_to_translate not in fieldnames:
            print(f"Error: '{field_to_translate}' is not a valid field name.")
            sys.exit(1)
        
        localizable_records = {}
        full_records = {}

        for row in reader:
            # Convert row keys to snake_case
            row = {snake_case(k): v for k, v in row.items()}
            localizable_records[row[id_column]] = row[field_to_translate]
            full_records[row[id_column]] = row

    localizable_output_filename = f"{base_filename}_localizable.json"
    full_output_filename = f"{base_filename}_full.json"
    
    # Write localizable records to JSON
    with open(localizable_output_filename, 'w', encoding='utf-8') as jsonfile:
        json.dump(localizable_records, jsonfile, ensure_ascii=False, indent=2)

    # Write full records to JSON
    with open(full_output_filename, 'w', encoding='utf-8') as jsonfile:
        json.dump(full_records, jsonfile, ensure_ascii=False, indent=2)

    print(f"Successfully created {localizable_output_filename} and {full_output_filename}")

if __name__ == "__main__":
    main()
