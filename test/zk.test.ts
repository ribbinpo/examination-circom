import { expect } from "chai";

const fs = require("fs");
const snarkjs = require("snarkjs");

// TODO: circuit.wasm, circuit_final.zkey, verification_key.json can store in IPFS
describe("zk", () => {
  const generateProof = async () => {
    const { proof, publicSignals } = await snarkjs.groth16.fullProve(
      { answer: "1", nonce: "123" },
      "zk/createAnswer_js/createAnswer.wasm",
      "zk/zkey/createAnswer_final.zkey"
    );
    return { proof, publicSignals };
  };

  it("should verify create answerHash proof", async () => {
    const { publicSignals, proof } = await generateProof();

    const vKey = JSON.parse(
      fs.readFileSync("zk/createAnswer_verification_key.json")
    );
    const result = await snarkjs.groth16.verify(vKey, publicSignals, proof);
    expect(result).eq(true);
  });

  it("should verify checkAnswer proof", async () => {
    const { proof, publicSignals } = await snarkjs.groth16.fullProve(
      {
        answer: "1",
        nonce: "123",
        answerHash:
          "1825367215715080944898610730329185918884251567885580835209236772238472514878",
      },
      "zk/checkAnswer_js/checkAnswer.wasm",
      "zk/zkey/checkAnswer_final.zkey"
    );
    const vKey = JSON.parse(
      fs.readFileSync("zk/checkAnswer_verification_key.json")
    );

    const result = await snarkjs.groth16.verify(vKey, publicSignals, proof);
    expect(result).eq(true);
  });
});
