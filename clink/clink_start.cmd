@echo off
:: Enable multigrid in neovide by default
set NEOVIDE_MULTIGRID=1
doskey vim=nvim $*
:: core utils
where coreutils > nul 2>&1 || echo "Installing core utils" && cargo binstall -y coreutils
for /F %%i in ('coreutils --list') do doskey %%i=coreutils %%i $*

:: use exa instead of ls
where eza  > nul 2>&1 || echo "Installing eza" && cargo binstall -y eza
doskey ls=eza $*

where fnm  > nul 2>&1 || echo "Installing fnm" && cargo binstall -y fnm
FOR /f "tokens=*" %%i IN ('fnm env --use-on-cd') DO CALL %%i
:: Use fnm over nvm
doskey nvm=fnm $*
where zoxide  > nul 2>&1 || echo "Installing zoxide" && cargo binstall -y zoxide

doskey ls=lazygiy $*


:: Shortcut for explorer
doskey ex=explorer $*

if %USERNAME%==jh49249 (curl -u %USERNAME%:%GITHUB_AT% -X PATCH https://github.deere.com/api/v3/user -d "{\"name\":\"Jake Hansen\"}" -H "Accept: application/vnd.github.v3+json" | json name) else (echo "not working")
