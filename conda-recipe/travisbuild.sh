#!/bin/bash
if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
else
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh;
fi
bash miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda install -q "conda-build<3.12"
if [ $TRAVIS_OS_NAME = linux ]; then
  QLIBDIR=l64; 
elif [ $TRAVIS_OS_NAME = osx ]; then 
  QLIBDIR=m64; fi;
export QLIBDIR
if [[ "x$QLIC_KC" != "x" ]]; then
  mkdir -p q
  echo -n $QLIC_KC |base64 --decode > q/kc.lic;
  export QLIC=$(pwd)/q;
fi
export EMBEDPY_VERSION=$TRAVIS_BRANCH
CONDAPACKAGE=$(conda build conda-recipe --output -c kx)
conda build -c kx conda-recipe --no-long-test-prefix
