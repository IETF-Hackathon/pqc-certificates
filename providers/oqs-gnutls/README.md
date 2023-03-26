# liboqs backed GnuTLS artifact generation and verification

To run the `gen.sh` and `check.sh` scripts, you need to install liboqs
and a private fork of GnuTLS with the instructions below:

```sh
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
cmake -DCMAKE_INSTALL_PREFIX=$(pwd)/../.local -DOQS_USE_OPENSSL=OFF -DBUILD_SHARED_LIBS=ON -S . -B _build
cmake --build _build && cmake --install _build
cd -
```

```sh
sudo dnf build-dep gnutls
git clone -b wip/dueno/dilithium-test https://gitlab.com/dueno/gnutls.git
cd gnutls
git submodule update --init
./bootstrap --skip-po
./configure --disable-doc --enable-pqc --prefix=$(pwd)/../.local \
	          CFLAGS="-I$(pwd)/../.local/include" \
	          LDFLAGS="-L$(pwd)/../.local/lib64 -Wl,-rpath,$(pwd)/../.local/lib64"
make -j$(nproc)
make install
cd -
```

Now the necessary binaries are installed under the `.local` directory.
Adjust the PATH envvar and run the scripts:

```sh
PATH=$(pwd)/.local/bin:$PATH
export PATH

./gen.sh
./check.sh
```
