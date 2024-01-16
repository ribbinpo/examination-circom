# if zk/ptau does not exist, make folder
[ -d zk/ptau ] || mkdir zk/ptau

# Phase1
# Start a new "powers of tau" ceremony, with 12 powers:
snarkjs powersoftau new bn128 12 zk/ptau/pot12_0000.ptau -v

# Contribute to ceremony a few times...
snarkjs powersoftau contribute zk/ptau/pot12_0000.ptau zk/ptau/pot12_0001.ptau --name="First contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
snarkjs powersoftau contribute zk/ptau/pot12_0001.ptau zk/ptau/pot12_0002.ptau --name="Second contribution" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

# Verify the contribution
snarkjs powersoftau verify zk/ptau/pot12_0002.ptau

# Apply random beacon to finalised this phase of the setup.
snarkjs powersoftau beacon zk/ptau/pot12_0002.ptau zk/ptau/pot12_beacon.ptau \
    0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

# Prepare phase 2...
snarkjs powersoftau prepare phase2 zk/ptau/pot12_beacon.ptau zk/ptau/pot12_final.ptau -v

# Verify the final ptau file. Creates the file pot12_final.ptau
snarkjs powersoftau verify zk/ptau/pot12_final.ptau