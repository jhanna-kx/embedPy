if not defined QLIC (
 goto :nokdb
)
conda create -y -n conda_test -c kx/label/dev kdb || goto :error
activate conda_test || goto :error
conda install -y --use-local embedpy || goto :error
conda install --file tests\requirements.txt || goto :error
q test.q || goto :error
echo tests complete
deactivate
exit /b 0

:error
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
