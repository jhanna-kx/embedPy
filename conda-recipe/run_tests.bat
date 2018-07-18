if not defined QLIC_KC (
 goto :nokdb
)
q test.q || goto :error
exit 0

:error
exit %errorLevel%

:nokdb
echo no kdb
exit 0
