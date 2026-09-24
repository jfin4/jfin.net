# Reproducible R on Windows (MSYS2)

[John Inman](/)

YYYY-MM-DD

## install rig

### windows

https://rig.r-lib.org/install.html
https://github.com/r-lib/rig/releases

pacman -S mingw-w64-ucrt-x86_64-innoextract
curl -LO --output-dir ~/software\
  https://github.com/r-lib/rig/releases/download/latest/rig-windows-latest.exe
innoextract ~/software/rig-windows-latest.exe

filed bug report
https://github.com/r-lib/rig/issues/401

### linux
method 1 worked
https://rig.r-lib.org/install.html#method-1-user-install-no-admin-rights-needed-1

rig config set mode=user

rig help
rig available
rig help add
rig add 4.5.3
rig add release
which R
rig help run
rig list
rig run -r 4.5.3
rig help

whole beatifulreference
https://rig.r-lib.org/reference/
is on board with help

rig help proj init





[Edit this page on GitHub](https://github.com/jfin4/jfin.net/edit/main/content/YYYY-MM-DD/reproducible-r.md)
