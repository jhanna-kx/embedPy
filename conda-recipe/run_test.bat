if not defined QLIC (
 goto :nokdb
)
call q conda-recipe/prep_requirements.q -q || goto :error
conda install -y -q --file tests\requirements_filtered.txt
q test.q -q || goto :error
exit /b 0

:error
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
