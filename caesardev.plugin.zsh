# Perf
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"

# Editor
alias vi=vim
alias vim=nvim
export EDITOR=vim

# StarDict console
# Install dicts into ~/.local/share/stardict/dic or /usr/share/stardict/dic
alias dict="sdcv -0 -c"

# Proxy shortcut
alias pc="proxychains4 -q"

# Ag searching
alias ag_scons='ag --ignore-dir="build" -G "(SConscript|SConstruct)"'
alias ag_cmake='ag --ignore-dir="build" -G "(ODPSBuild.txt|CMakeLists.txt|.\.cmake)"'
alias ag_bazel='ag --ignore-dir="build" -G "(BUILD|.\.bazel)"'

# java
alias java_decompile="java -jar $HOME/.local/bin/cfr-0.152.jar"

#+++++++++++++++++++++++++++++++++++++++
# functions
#+++++++++++++++++++++++++++++++++++++++

# Quick start a maven project with template
function maven-quickstart {
    mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DarchetypeVersion=1.4 $@
}

# Quick start a local http server with python
function local-http-server {
    # Check python major version
    PYV=$(python -c "import sys;t='{v[0]}'.format(v=list(sys.version_info[:1]));sys.stdout.write(t)")
    if [ "$PYV" -eq "3" ]; then
        python -m http.server 8899
    else
        python -m SimpleHTTPServer 8899
    fi
}

function _flatpak_aliases {
    FLATPAK_HOME=/var/lib/flatpak
    FLATPAK_BIN=${FLATPAK_HOME}/exports/bin

    # shortcuts to apps installed by flatpak
    if command -v flatpak &>/dev/null; then
        export PATH=$PATH:${FLATPAK_BIN}
        if [ -e ${FLATPAK_BIN}/com.visualstudio.code ]; then
            # Specifically
            alias code="flatpak run com.visualstudio.code"
        fi
    fi

    flatpak_exports=/var/lib/flatpak/exports/bin
    if [ -e ${flatpak_exports} ]; then
        for i in $(ls ${flatpak_exports}); do
            alias run-$i="flatpak run $i"
        done
    fi
}

# Alias for AppImages in ~/.local/share/appimage
function _appimages_aliases {
    appimage_dir=$HOME/.local/share/appimages
    if [ -e ${appimage_dir} ]; then
        for i in $(find ${appimage_dir} -name "*.AppImage"); do
            filename=$(basename -- "$i")
            alias run-${filename%.*}="${i}"
        done
    fi
}

function _initGoenv {
    GOROOT=${GOROOT:-/usr/local/go}
    if [ -e $GOROOT ]; then
        export GOROOT=$GOROOT
        export PATH=$PATH:$GOROOT/bin
    fi
    if command -v go &>/dev/null; then
        export GOPATH=$(go env GOPATH)
        export PATH=$PATH:$GOPATH/bin
        export GO111MODULE=on
        export GOPROXY=https://goproxy.cn,direct
    fi
}

function _initRustEnv {
    if command -v rustc &>/dev/null; then
        export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
        export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
    fi
    if [ -e "$HOME/.cargo" ]; then
        export PATH="$HOME/.cargo/bin":$PATH
    fi
}

function _initCuda {
    if [ -e "/usr/local/cuda" ]; then
        export PATH="/usr/local/cuda/bin$PATH"
        export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
    fi
}

function _initMacEnv {
    # homebrew
    # brew_installed=(gcc) #***
    # if command -v brew &>/dev/null; then
    # 	for i in ${brew_installed[@]}; do
    # 		INSTALLED_HOME=$(brew --prefix ${i})
    # 		if [[ "x$?" == "x0" ]]; then
    # 			export PATH=$INSTALLED_HOME/bin:$PATH
    # 		fi
    # 	done
    # fi
    # speedup
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    # macports
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    export C_INCLUDE_PATH="/opt/local/include:$C_INCLUDE_PATH"
    export LD_LIBRARY_PATH="/opt/local/lib:$LD_LIBRARY_PATH"
    # skim shortcut
    alias skim="/Applications/Skim.app/Contents/MacOS/Skim"
}

function _initHaskellEnv {
    if [ -e "$HOME/.ghcup" ]; then
        export PATH="$HOME/.ghcup/bin:$PATH"
    fi
    if [ -e "$HOME/.cabal" ]; then
        export PATH="$HOME/.cabal/bin:$PATH"
    fi
}

function _mymain_ {
    _initGoenv
    _initRustEnv
    _initCuda
    _initHaskellEnv
    if [[ $OSTYPE == darwin* ]]; then
        _initMacEnv
    fi
    _flatpak_aliases
    _appimages_aliases
}

_mymain_
