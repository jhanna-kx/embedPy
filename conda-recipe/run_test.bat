if not defined QLIC (
 goto :nokdb
)
q conda-recipe/prep_requirements.q -q || goto :error
echo installing
conda install -y -q --file tests\requirements_filtered.txt
echo installed
q test.q -q || goto :error
echo tests run
exit /b 0

:error
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
