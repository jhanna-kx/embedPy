if [[ "x$QLIC_KC" != "x" ]]; then
  echo -n $QLIC_KC |base64 --decode > kc.lic;
  pip3 -q install -r tests/requirements.txt;
  q test.q -q;
else
  echo No kdb+, no tests;
fi
