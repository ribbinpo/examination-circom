# if zk/proof does not exist, make folder
[ -d zk/proof ] || mkdir zk/proof

# Generate witness
node zk/createAnswer_js/generate_witness.js zk/createAnswer_js/createAnswer.wasm zk/proof/createAnswer_input.json zk/proof/createAnswer_witness.wtns
node zk/checkAnswer_js/generate_witness.js zk/checkAnswer_js/checkAnswer.wasm zk/proof/checkAnswer_input.json zk/proof/checkAnswer_witness.wtns

# Generating a Proof
snarkjs groth16 prove zk/zkey/createAnswer_final.zkey zk/proof/createAnswer_witness.wtns zk/createAnswer_proof.json zk/proof/createAnswer_public.json
snarkjs groth16 prove zk/zkey/checkAnswer_final.zkey zk/proof/checkAnswer_witness.wtns zk/checkAnswer_proof.json zk/proof/checkAnswer_public.json

# Verify a Proof
snarkjs groth16 verify zk/createAnswer_verification_key.json zk/proof/createAnswer_public.json zk/createAnswer_proof.json
snarkjs groth16 verify zk/checkAnswer_verification_key.json zk/proof/checkAnswer_public.json zk/checkAnswer_proof.json
