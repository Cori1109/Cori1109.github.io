call .\bin\hugo.bat

set date=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%

git commit -am "deploy: %date%"
REM git subtree split --prefix public -b gh-pages
REM git push -f origin gh-pages:master
REM git branch -D gh-pages
git push -f
