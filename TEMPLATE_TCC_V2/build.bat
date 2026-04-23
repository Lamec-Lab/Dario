@echo off

set MAIN=main

echo Compiling %MAIN%.tex...

latexmk -pdf -pdflatex=lualatex -interaction=nonstopmode -synctex=1 %MAIN%.tex

echo.
echo Cleaning...

latexmk -c

echo Done!
pause