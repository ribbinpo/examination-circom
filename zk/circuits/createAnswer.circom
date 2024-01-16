pragma circom 2.1.6;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template CreateAnswer() {
  signal input nonce;
  signal input answer;

  signal output answerHash;

  component poseidon = Poseidon(2);
  poseidon.inputs[0] <== nonce;
  poseidon.inputs[1] <== answer;

  answerHash <-- poseidon.out;
}

component main = CreateAnswer();