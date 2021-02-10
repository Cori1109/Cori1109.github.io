call .\bin\hugo.bat

git commit -am "deploy: $(date)"
git subtree split --prefix public -b gh-pages
git push -f origin gh-pages:master
git branch -D gh-pages
git push -f
