# Reproducible R on Windows (MSYS2)

[John Inman](/)

YYYY-MM-DD

## install rig

https://rig.r-lib.org/install.html
https://github.com/r-lib/rig/releases

pacman -S mingw-w64-ucrt-x86_64-innoextract
curl -LO --output-dir ~/software\
  https://github.com/r-lib/rig/releases/download/latest/rig-windows-latest.exe
innoextract ~/software/rig-windows-latest.exe


```
curl -L -J --output-dir ~/software -O\
  https://github.com/r-lib/rig/archive/refs/tags/v0.10.0.zip
  # https://github.com/r-lib/rig/releases/download/v0.10.0/rig-windows-arm64-0.10.0.exe
unzip ~/software/rig-0.10.0.zip -d ~/.local
echo $PATH | grep -q ~/.local/bin && echo true
```

```
```


[Edit this page on GitHub](https://github.com/jfin4/jfin.net/edit/main/content/YYYY-MM-DD/reproducible-r.md)
