pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom";
include "../../node_modules/circomlib-matrix/circuits/matSub.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    // Get the result for each element of the system
    component mul = matElemMul(n, n);

    for(var i=0; i<n; i++) {
      for(var j=0; j<n; j++) {
        mul.a[i][j] <== x[j];
        mul.b[i][j] <== A[i][j];
      }
    }

    // Calculate the result of each equation based on the solution
    component equation[n];

    for(var i=0; i<n; i++) {
      equation[i] = matElemSum(1, n);

      for(var j=0; j<n; j++) {
        equation[i].a[0][j] <== mul.out[i][j];
      }
    }

    // Subtract the calculated result from the constants
    component sub = matSub(1, n);
    for (var i=0; i<n; i++) {
      sub.a[0][i] <== equation[i].out;
      sub.b[0][i] <== b[i];
    }

    // Sum all of the results, which should be zero if the solution is
    // correct
    component sum = matElemSum(1, n);
    for (var i=0; i<n; i++) {
      sum.a[0][i] <== sub.out[0][i];
    }

    // Check if the sum is zero
    component isZero = IsZero();
    isZero.in <== sum.out;
    out <== isZero.out;
}

component main {public [A, b]} = SystemOfEquations(3);
