# if zk/zkey does not exist, make folder
[ -d zk/zkey ] || mkdir zk/zkey

# Compile circuits
circom zk/circuits/createAnswer.circom -o zk/ --r1cs --wasm
circom zk/circuits/checkAnswer.circom -o zk/ --r1cs --wasm

# Setup
snarkjs groth16 setup zk/createAnswer.r1cs zk/ptau/pot12_final.ptau zk/zkey/createAnswer_0000.zkey -v
snarkjs groth16 setup zk/checkAnswer.r1cs zk/ptau/pot12_final.ptau zk/zkey/checkAnswer_0000.zkey -v

# Contribute to the phase n of the ceremony
snarkjs zkey contribute zk/zkey/createAnswer_0000.zkey zk/zkey/createAnswer_0001.zkey --name="1st createAnswer Contributor Name" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
snarkjs zkey contribute zk/zkey/checkAnswer_0000.zkey zk/zkey/checkAnswer_0001.zkey --name="1st checkAnswer Contributor Name" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

snarkjs zkey contribute zk/zkey/createAnswer_0001.zkey zk/zkey/createAnswer_0002.zkey --name="2nd createAnswer Contributor Name" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"
snarkjs zkey contribute zk/zkey/checkAnswer_0001.zkey zk/zkey/checkAnswer_0002.zkey --name="2nd checkAnswer Contributor Name" -v -e="$(head -n 4096 /dev/urandom | openssl sha1)"

# Verify zkey
snarkjs zkey verify zk/createAnswer.r1cs zk/ptau/pot12_final.ptau zk/zkey/createAnswer_0002.zkey
snarkjs zkey verify zk/checkAnswer.r1cs zk/ptau/pot12_final.ptau zk/zkey/checkAnswer_0002.zkey

# Apply random beacon as before
snarkjs zkey beacon zk/zkey/createAnswer_0002.zkey zk/zkey/createAnswer_final.zkey \
    0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="createAnswer FinalBeacon phase2"

snarkjs zkey beacon zk/zkey/checkAnswer_0002.zkey zk/zkey/checkAnswer_final.zkey \
    0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="checkAnswer Beacon phase2"

# Optional: verify final zkey
snarkjs zkey verify zk/createAnswer.r1cs zk/ptau/pot12_final.ptau zk/zkey/createAnswer_final.zkey
snarkjs zkey verify zk/checkAnswer.r1cs zk/ptau/pot12_final.ptau zk/zkey/checkAnswer_final.zkey

# Export verification key
snarkjs zkey export verificationkey zk/zkey/createAnswer_final.zkey zk/createAnswer_verification_key.json
snarkjs zkey export verificationkey zk/zkey/checkAnswer_final.zkey zk/checkAnswer_verification_key.json

# Export solidity verifier
snarkjs zkey export solidityverifier zk/zkey/createAnswer_final.zkey contracts/createAnswerVerifier.sol
snarkjs zkey export solidityverifier zk/zkey/checkAnswer_final.zkey contracts/checkAnswerVerifier.sol
