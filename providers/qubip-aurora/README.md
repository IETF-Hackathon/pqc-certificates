# [QUBIP] aurora Artifacts

The `gen.py` script will generate DER artifacts in the v5 format.
It assumes `openssl` is configured to load the [aurora provider].

For convenience, we have a preconfigured container running Fedora 42 (w/ OpenSSL 3.2) preconfigured to load the aurora provider:

`podman run --rm -it -v $PWD:/work --workdir /work docker.io/nisectuni/pq-container:f42-aurora-nt`

Then:
```sh
cd providers/qubip-aurora
./gen.py
dnf install -y zip
zip -j artifacts_certs_r5.zip artifacts_certs_r5/*.der
```

[QUBIP]: https://qubip.eu
[aurora provider]: https://github.com/QUBIP/aurora
