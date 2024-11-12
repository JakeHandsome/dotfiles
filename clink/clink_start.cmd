@echo off
:: Enable multigrid in neovide by default
set NEOVIDE_MULTIGRID=1
doskey vim=nvim $*
:: core utils
where coreutils > nul 2>&1 || echo "Installing core utils" && cargo binstall -y coreutils
for  %%i in (arch b2sum b3sum base32 base64 basename basenc cat cksum comm cp csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt hashsum hostname join link ln md5sum mkdir mktemp more mv nl nproc numfmt od paste pr printenv printf ptx pwd readlink realpath relpath rm rmdir runcon seq sha1sum sha224sum sha256sum sha3-224sum sha3-256sum sha3-384sum sha3-512sum sha384sum sha3sum sha512sum shake128sum shake256sum shred shuf sleep sort split sum sync tac tail tee test touch tr true truncate tsort uname unexpand uniq unlink vdir wc whoami yes) do doskey %%i=coreutils %%i $*

:: use exa instead of ls
where eza  > nul 2>&1 || echo "Installing eza" && cargo binstall -y eza
doskey ls=eza $*

where fnm  > nul 2>&1 || echo "Installing fnm" && cargo binstall -y fnm
FOR /f "tokens=*" %%i IN ('fnm env --use-on-cd') DO CALL %%i
:: Use fnm over nvm
doskey nvm=fnm $*
where zoxide  > nul 2>&1 || echo "Installing zoxide" && cargo binstall -y zoxide



:: Shortcut for explorer
doskey ex=explorer $*

if %USERNAME%==jh49249 (curl -u %USERNAME%:%GITHUB_AT% -X PATCH https://github.deere.com/api/v3/user -d "{\"name\":\"Jake Hansen\"}" -H "Accept: application/vnd.github.v3+json" | json name) else (echo "not working")
