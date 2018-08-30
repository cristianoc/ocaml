
type t = { a: int; b: t option};;
let testoa (x:t option) = x.a;;
let testb x = x.b;;
let testbb x = x.b.b;;
let testbba x = x.b.b.a;;


let check (x,s) = Printf.printf "%s -- %b\n" s x;;

check((None).a = None, "(None).a = None");;
check((None).b = None, "(None).b = None");;
check((Some {a=1; b=None}).a = Some(1), "(Some {a=1; b=None}).a = Some(1)");;
check((Some {a=1; b=None}).b = None, "(Some {a=1; b=None}).b = None");;
check(testbba {a=1; b=None} = None, "testbba {a=1; b=None} = None");;
check(testbba {a=1; b=Some{a=2; b=None}} = None, "testbba {a=1; b=Some{a=2; b=None}} = None");;
check(testbba {a=1; b=Some{a=2; b=Some{a=3; b=None}}} = Some(3), "testbba {a=1; b=Some{a=2; b=Some{a=3; b=None}}} = Some(3)");;
