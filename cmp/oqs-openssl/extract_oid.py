# This tool parses the output of `openssl list -objects -provider oqsprovider` to prepare a dictionary that maps an
# algorithm mnemonic identifier to its OID, e.g. "p521_dilithium5_aes" -> "1.3.9999.2.11.4"


def clean_up(lines):
    result = []
    for line in lines:
        if line.startswith('#'):
            # ignore commented lines
            continue
        elif not line.strip():
            # ignore empty lines
            continue
        result.append(line.strip())
    return result


def prepare_dict(lines):
    result = {}
    for line in lines:
        mnemonic, meta = line.split('=')
        mnemonic = mnemonic.strip()

        if ',' in meta:
            # some lines contain an expanded name of the algorithm besides the OID, in this case we take just the OID
            # example: "countersignature = 1.2.840.113549.1.9.6"
            oid = meta.split(',')[-1].strip()
        else:
            # otherwise we use the OID "as is"
            oid = meta.strip()

        if oid.endswith('.'):
            # some OIDs end with a dot, we remove that dot, e.g. "uacurve9 = DSTU curve 9, 1.2.804.2.1.1.1.1.3.1.1.2."
            oid = oid[:-1]

        result[mnemonic] = oid
    return result


if __name__ == '__main__':
    raw = open('algorithm_oids.txt', 'r').readlines()
    lines = clean_up(raw)

    alg_oid = prepare_dict(lines)
    stringified = str(alg_oid)
    stringified = stringified.replace(',', ',\n')
    open('algorithm_oids.py', 'w').write(f'ALG_OID = {stringified}')
