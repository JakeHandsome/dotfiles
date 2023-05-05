:: Script to build lastest neovim for windows, the first argument is path to neovim git repo
pushd %1
git checkout release-0.9
git pull
git clean -fxd
cmake -S cmake.deps -B .deps -G Ninja -DCMAKE_BUILD_TYPE='Release'
cmake --build .deps
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE='Release'  -DCMAKE_INSTALL_PREFIX="C:/Program Files/nvim"
cmake --build build
sudo ninja -C build install
popd

:: Update nvim plugins
nvim --headless "+Lazy! sync" +qa
