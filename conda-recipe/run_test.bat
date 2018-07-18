if not defined QLIC_KC (
 goto :nokdb
)
echo|set /P =%QLIC_KC% >kc.lic.enc
certutil -decode kc.lic.enc kc.lic
set QLIC=%CD%
q test.q || goto :error
exit 0

:error
exit %errorLevel%

:nokdb
echo no kdb
exit 0
