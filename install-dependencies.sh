#!/bin/bash

function check_install_homebrew() {    
    if [[ ! $(which brew) ]]; then
        echo "Installing homebrew... "
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

check_install_homebrew