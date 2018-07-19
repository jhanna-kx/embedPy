if [[ "x$QLIC" != "x" ]]; then
  q test.q -q;
else
  echo No kdb+, no tests;
fi
