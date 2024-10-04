import os
import argparse
from pyasn1.codec.der import decoder
from pyasn1_alt_modules import rfc9480


def parse_payload(raw):
    """Attempt to parse the raw buffer as a PKIMessage"""
    parsed_data, _ = decoder.decode(raw, asn1Spec=rfc9480.PKIMessage())
    return parsed_data
    
    
    
def process_pki_messages(directory):
    files_parsed = 0
    errors = 0
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.pkimessage'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'rb') as f:
                        raw_data = f.read()
                        parsed_data = parse_payload(raw_data)
                        print(f"OK  '{file}'")
                except Exception as e:
                    errors += 1
                    print(f"ERR '{file_path}': {str(e)[:60]}...")
                else:
                    files_parsed += 1
                    
    print(f'OK: {files_parsed}\tERR: {errors}')


    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parse PKIMessage files in directories')
    parser.add_argument('directory', help='Path to the directory to start from')
    args = parser.parse_args()

    if os.path.isdir(args.directory):
        process_pki_messages(args.directory)
    else:
        print(f"Error: The provided path '{args.directory}' is not a directory.")
