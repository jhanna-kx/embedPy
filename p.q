if[system["s"]|0>system"p";'"slaves or multithreaded input not currently supported"];
.p:(`:./p 2:`lib,1)`
\d .p
ei:{n:`$(2+x)_(y?"(")#y;eo y _ x;n set .p.get[n]value y x;}
eo:{x[0]y;}runs
e:{$["def"~3#x;$[x[3]in"<*>";ei 3;eo];"class"~5#x;$[x[5]in"*>";ei 5;eo];eo]x}
.p.eval:runs 1

k)c:{'[y;x]}/|:         / compose list of functions
k)ce:{'[y;x]}/enlist,|: / compose with enlist (for variadic functions)

/ Aliases
set'[`pykey`pyvalue`pyget`pyeval`pyimport`arraydims;.p.key,.p.value,.p.get,.p.eval,import,getarraydims];
qeval:c`.p.py2q,pyeval

/ Wrapper for foreigns
embedPy:{[c;r;x;a] / r (0 wrapped, 1 q, 2 foreign)
  if[102<>type a0:a 0;if[c;:(wrap;py2q;::)[r].[pyfunc x]a]];
  $[($)~a0;:x;`.~a0;:x;`~a0;:py2q x;-11=type a0;x:x getattr/` vs a0;
  (:)~a0;[setattr . x,1_a;:(::)];
  [c:1;r:$[(*)~a0;0;(<)~a0;1;(>)~a0;2;'`NYI]]];
  $[count a:1_a;.[;a];]i.w[c;r]x}
i.wf:{[c;r;x;a]embedPy[c;r;x;a]}
wrap:(i.w:{[c;r;x]ce i.wf[c;r;x]})[0;0]
unwrap:{$[105=type x;x($);x]}
wfunc:{[f;x]r:wrap f x 0;$[count x:1_x;.[;x];]r}
import:ce wfunc pyimport
.p.eval:ce wfunc pyeval
.p.get:ce wfunc pyget
.p.set:{[f;x;y]f[x]unwrap y;}.p.set
.p.key:{wrap pykey$[i.isf x;x;i.isw x;x($);'`type]}
.p.value:{wrap pyvalue$[i.isf x;x;i.isw x;x($);'`type]}
.p.callable:{$[i.isw x;x(*);i.isf x;wrap[x](*);'`type]}
.p.pycallable:{$[i.isw x;x(>);i.isf x;wrap[x](>);'`type]}
.p.qcallable:{$[i.isw x;x(<);i.isf x;wrap[x](<);'`type]}
/ is foreign, wrapped, callable
i.isf:112=type@ 
i.isw:{$[105=type x;i.wf~$[104=type u:first get x;first get u;0b];0b]}
i.isc:{$[105=type x;$[last[u:get x]~ce 1#`.p.q2pargs;1b;0b];0b]}
setattr:{[f;x;y;z]f[x;y;z];}import[`builtins;`setattr;*]

/ Converting python to q
py2q:{$[i.isf x;conv .p.type[x]0;]x} / convert to q using best guess of type
dict:{({$[all 10=type@'x;`$;]x}py2q pykey x)!py2q pyvalue x}
scalar:.p.eval["lambda x:x.tolist()";<]
/ conv: type -> convfunction
conv:neg[1 3 7 9 21 30h]!getb,getnone,getj,getf,repr,scalar
conv[4 10 30 41 42 99h]:getG,getC,{d#x[z;0]1*/d:y z}[getarray;getarraydims],(2#(py2q each getseq@)),dict

/ Calling python functions
pyfunc:{if[not i.isf x;'`type];ce .[.p.call x],`.p.q2pargs}
q2pargs:{
 if[x~enlist(::);:(();()!())]; / zero args
 hd:(k:i.gpykwargs x)0; 
 al:neg[hd]_(a:i.gpyargs x)0;
 if[any 1_prev[u]and not u:i.isarg[i.kw]each neg[hd]_x;'"keywords last"]; / check arg order
 cn:{$[()~x;x;11<>type x;'`type;x~distinct x;x;'`dupnames]};
 :(unwrap each x[where not[al]&not u],a 1;cn[named[;1],key k 1]!(unwrap each named:get'[(x,(::))where u])[;2],value k 1)
 }
if[not`pykw      in key`.q;.p.pykw:     {x[y;z]}i.kw:(`..pykw;;;);.q.pykw:.p.pykw]           / identify keyword args with `name pykw value
if[not`pyarglist in key`.q;.p.pyarglist:{x y}i.al:(`..pyas;;)    ;.q.pyarglist:.p.pyarglist] / identify pos arg list (*args in python)
if[not`pykwargs  in key`.q;.p.pykwargs: {x y}i.ad:(`..pyks;;)    ;.q.pykwargs:.p.pykwargs]   / identify keyword dict (**kwargs in python)
i.gpykwargs:{dd:(0#`)!();
 $[not any u:i.isarg[i.ad]each x;(0;dd);not last u;'"pykwargs last";
  1<sum u;'"only one pykwargs allowed";(1;dd,get[x where[u]0]1)]}
i.gpyargs:{$[not any u:i.isarg[i.al]each x;(u;());1<sum u;'"only one pyargs allowed";(u;(),get[x where[u]0]1)]}
i.isarg:{$[104=type y;x~first get y;0b]} / y is python argument identifier x

/ Help & Print
gethelp:{[h;x]$[i.isf x;h x;i.isw x;h x($);i.isc x;h 2{last get x}/first get x;"no help available"]}
repr:gethelp repr
help:{[gh;h;x]if[10=type u:gh[h]x;-2 u]}[gethelp]import[`builtins;`help;*] 
helpstr:gethelp import[`inspect;`getdoc;<]
print:{x y;}import[`builtins;`print;*]
{@[`.;x;:;get x]}each`help`print; / comment to remove from global namespace

/ Closures
p)def qclosure(func,*state):
  def cfunc(a0=None,*args):
    nonlocal state
    res=func(*state+(a0,)+args)
    state=(res[0],)
    return res[1]
  return cfunc
closure:.p.get[`qclosure;*] / implement as: closure[{[state;dummy] ...;(newState;result)};initState]

/ Generators
p)import itertools
i.gl:.p.eval["lambda f,n:(f(x)for x in(itertools.count()if n==None else range(n)))"][>]
generator:{[f;i;n]i.gl[closure[f;i]($);n]}

/ Cleanup
{![`.p;();0b;x]}`getseq`getb`getnone`getj`getf`getG`getC`getarraydims`getarray`getbuffer`dict`scalar`ntolist`runs`wfunc`gethelp;
