@echo off
setlocal EnableExtensions

python -c "import uuid; print(str(uuid.uuid4()).upper())"

endlocal