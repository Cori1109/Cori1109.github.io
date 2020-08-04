call .\bin\hugo.bat
git commit -am update
git subtree split --prefix public -b gh-pages
REM n.b. removes cutstom domain git push -f origin gh-pages:master
git push -f origin master
git branch -D gh-pages
