// slimmed-down version of ri-6-named.chpl
// using 'userReduceInstance' instead of UserReduceOp

config const n = 9999;
var ARR: [1..n] int = 1..n;
var numErrors = 0;

// A (simplified) copy of the predefined SumReduceScanOp.
class UserReduceOp: ReduceScanOp {
  type eltType;
  var value: eltType;

  proc identity         return 0: eltType;
  proc accumulate(elm)  { value = value + elm; }
  proc accumulateOntoState(ref state, elm) { state = state + elm; }
  proc combine(other)   { value = value + other.value; }
  proc generate()       return value;
  proc clone()          return new UserReduceOp(eltType=eltType);
}

proc check(test:string, expected: int, actual: int) {
  if actual != expected then
    writeln(test, ":  expected ", expected, ",  computed ", actual);
  numErrors += (actual != expected);
}

proc main {
  writeln("n = ", n);

  var sumUsr1 = 35, sumUsr2 = 36, sumUsr3 = 37;
  const userReduceInstance = new UserReduceOp(eltType=int);

  forall arrElm in ARR with (userReduceInstance reduce sumUsr1,
                             new UserReduceOp(eltType=int) reduce sumUsr2)
  {
    sumUsr1 = sumUsr1 + arrElm;
    sumUsr2 += arrElm;
  }

  writeln("forall finished");

  testFormals(sumUsr3, new UserReduceOp(eltType=int));

  check("sumUsr1", 35 + n*(n+1)/2, sumUsr1);
  check("sumUsr2", 36 + n*(n+1)/2, sumUsr2);
  check("sumUsr3", 37 + n*(n+1)/2, sumUsr3);
  check("UserReduceOp reduce ARR", n*(n+1)/2, UserReduceOp reduce ARR);

  if numErrors then
    writeln("NUMERRORS: ", numErrors);
  else
    writeln("success");
}

proc testFormals(ref sumUsr3: int, userOp: UserReduceOp(int)) {
  forall arrElm in ARR with (userOp reduce sumUsr3) {
    sumUsr3 reduce= arrElm;
  }
}
