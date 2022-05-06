const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/;
const verifierRegex = /contract Verifier/;

function updateVerifier(name) {
  let content = fs.readFileSync(`./contracts/${name}Verifier.sol`, {
    encoding: "utf-8",
  });
  let bumped = content.replace(solidityRegex, "pragma solidity ^0.8.0");
  bumped = bumped.replace(verifierRegex, `contract ${name}Verifier`);

  fs.writeFileSync(`./contracts/${name}Verifier.sol`, bumped);
}

updateVerifier("HelloWorld");

// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment
updateVerifier("Multiplier3");
