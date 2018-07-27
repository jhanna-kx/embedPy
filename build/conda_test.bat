if not defined QLIC (
 goto :nokdb
)
echo install embedpy
conda install -y --use-local embedpy || goto :error
echo install requirements
conda install -y --file tests\requirements.txt || goto :error
echo run tests
q test.q || goto :error
echo tests complete
exit /b 0

:error
echo error
echo ERROR
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
