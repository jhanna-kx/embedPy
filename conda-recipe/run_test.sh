#!/bin/bash
if [ -e ${QLIC}/kc.lic ] 
then
  q test.q -q;
else
  echo No kdb+, no tests;
fi
