#!/bin/bash
if [[ "x$QLIC" != "x" ]]; then
  echo QHOME is $QHOME
  q test.q -q;
else
  echo No kdb+, no tests;
fi
