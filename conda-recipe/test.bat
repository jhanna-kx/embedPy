if not defined QLIC (
 goto :nokdb
)
echo create environment
conda create -y -n conda_test -c kx/label/dev kdb || goto :error
echo activate environment
activate conda_test || goto :error
echo install embedpy
conda install -y --use-local embedpy || goto :error
echo install requirements
conda install --file tests\requirements.txt || goto :error
echo run tests
q test.q || goto :error
echo tests complete
deactivate
exit /b 0

:error
echo error
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
