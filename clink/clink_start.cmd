@echo off
curl -u %USERNAME%:%GITHUB_AT% -X PATCH https://github.deere.com/api/v3/user -d "{\"name\":\"Jake Hansen\"}" -H "Accept: application/vnd.github.v3+json" | json name

:: Enable multigrid in neovide by default
set NEOVIDE_MULTIGRID=1

:: Make cd always behave like cd /D
doskey cd=cd /D $*
:: use exa instead of ls
doskey ls=exa $*
doskey vim=nvim $*
