#!/bin/bash
make p.so
mv p.q p.k $QHOME
mv $QLIBDIR/p.so $QHOME/$QLIBDIR
