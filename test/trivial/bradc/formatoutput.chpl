var x: integer = 10;

writeln("x is: ", x);
writeln("x is: ", ("%3lld", x));
writeln("x is: ", ("%.3lld", x));

var D: domain(1) = 1..4;
var A: [D] integer;

forall i in D {
  A(i) = 3;
}

writeln("A is: ", A);
writeln("A is: ", ("%2lld", A));
writeln("A is: ", ("%.2lld", A));
