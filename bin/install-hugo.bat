set GOARCH=386
set GOOS=windows
set CGO_ENABLED=1

git clone https://github.com/gohugoio/hugo.git
cd hugo
go install --tags extended