pragma circom 2.1.6;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template CheckAnswer() {
  signal input nonce;
  signal input answer;
  signal input answerHash;

  signal output valid;

  component poseidon = Poseidon(2);
  poseidon.inputs[0] <== nonce;
  poseidon.inputs[1] <== answer;

  valid <-- poseidon.out == answerHash;
}

component main { public [answer, answerHash] } = CheckAnswer();