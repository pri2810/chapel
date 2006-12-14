/*
 *
 *  Matrix and Vector Norms Example
 *
 *  Norm module for computing matrix and vector norms:
 *  1-norm, 2-norm and infinity norm for vectors
 *  1-norm, infinity norm and Frobenius norm for matrices
 * 
 *  normType specifies the type of norm to use
 *  norm function may be called without specifying normType
 *
 *  TestNorm module tests norm function for 1-D and 2-D arrays 
 *
 */
module Norm{

  // normType specifies the type of norm to compute
  enum normType {norm1, norm2, normInf, normFrob};

  def norm(x: [], p: normType) where x.rank == 1 {
  // vector norms
    select (p) {
      when norm1 do return + reduce abs(x);
      when norm2 do return sqrt(+ reduce (abs(x)*abs(x)));
      when normInf do return max reduce abs(x);
      when normFrob do halt("Frobenius norm not defined for 1D arrays");
      otherwise halt("Unexpected norm type");
    }
  }

  def norm(x: [?D], p: normType) where x.rank == 2 {
  // matrix norms
    select (p) {
      when norm1 do
        return max reduce [j in D(2)] (+ reduce abs(x[D(1), j]));

      when norm2 do
        halt("Haven't implemented 2-norm for 2D arrays yet");

      when normInf do
        return max reduce [i in D(1)] (+ reduce abs(x[i, D(2)]));

      when normFrob do return sqrt(+ reduce (abs(x)*abs(x)));

      otherwise halt("Unexpected norm type");
    }
  }

  def norm(x: [], p: normType) where x.rank > 2 {
  // norms not implemented for > 2D arrays
    compilerError("Norms not implemented for array ranks > 2D");
  }

  def norm(x: []) {
  //  default norms
    select (x.rank) {
      when 1 do return norm(x, norm2);
      when 2 do return norm(x, normFrob);
      otherwise compilerError("Norms not implemented for array ranks > 2D");
    }
  }
}


module TestNorm {
  use Norm;

  def testNorm(arr: []) {
    var testType = if (arr.rank == 1) then "vector" else "matrix";
    writeln("Test of ", testType, " norms.  Array = ");
    writeln(arr);
    writeln("1-norm = ", norm(arr, norm1));
    if (arr.rank == 1) then
      writeln("2-norm = " , norm(arr, norm2));
    writeln("infinity norm = ", norm(arr, normInf));
    if (arr.rank == 2) then
      writeln("frobenius norm = ", norm(arr, normFrob));
    writeln("default norm = ", norm(arr));
    writeln();
  }

  def main() {
    const D1 = [1..4];
    var a:[D1] real;
    a = 2.0;
    testNorm(a);

    const D2 = [1..2,1..2];
    var b:[D2] real;
    b = 2.0;
    testNorm(b);

    const D3 = [1..3,1..2];
    var c:[D3] real;
    c = 2.0;
    testNorm(c);

    var d:[D2] int;
    d = 1;
    testNorm(d);

    var e:[D2] complex;
    e = 1.0 + 1.0i;
    testNorm(e);
  }
}
