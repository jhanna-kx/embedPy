tab2df:{
  r:.p.import[`pandas;`:DataFrame.from_dict;flip 0!x][@;cols x];
  $[count k:keys x;r[`:set_index]k;r]}
df2tab:{
  n:$[.p.isinstance[x`:index;.p.import[`pandas]`:RangeIndex]`;0;x[`:index.nlevels]`];
  n!raze[`$$[n;x[`:index.names]`;0#`],x[`:columns.values]`]xcols flip$[n;x[`:reset_index][];x][`:to_dict;`list]`}
k:1!`c3`c2`c1 xcols x:([]c1:1 2 3;c2:("one";"two";"three");c3:1.5 2.5 3.5)
$[(a:x)~b:df2tab c:tab2df x;1b;[show a;show b;.p.print c;0b]]
$[(a:k)~b:df2tab c:tab2df k;1b;[show a;show b;.p.print c;0b]]
