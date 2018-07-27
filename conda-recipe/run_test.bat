if not defined QLIC (
 goto :nokdb
)
echo 0N!`qruns | q
echo run tests
q test.q || goto :error
echo done
exit /b 0

:error
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
