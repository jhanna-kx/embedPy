if [[ "x$QLIC_KC" != "x" ]]; then
  echo -n $QLIC_KC |base64 --decode > kc.lic;
  export QLIC=$(pwd);
  q test.q -q;
else
  echo No kdb+, no tests;
fi
