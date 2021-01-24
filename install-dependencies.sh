#!/bin/bash

# GLOBALS
SHELL_ENVIRONMENT_CONFIGURATION_FILE=
GENERIC_ERROR_ENDING=" is not yet supported by this script"

function exit_with_error_messsage() {
    local message="$@"
    echo $message
    exit 1
}

function exit_with_generic_error_message_ending() {
    local error_message_start="$@"
    exit_with_error_messsage="$error_message_start$GENERIC_ERROR_ENDING"
}

function set_shell_environment_configuration_file() {
    local shell_configuration_file
    if [[ $SHELL == "/bin/bash" ]]; then
        shell_configuration_file="$HOME/.profile"
    elif [[ $SHELL == "/bin/zsh" ]]; then
        shell_configuration_file="$HOME/.zshenv"
    else 
        exit_with_generic_error_messsage_ending "Shell type $SHELL"
    fi
    if [[ ! -f $shell_configuration_file ]]; then
        touch $shell_configuration_file
    fi
    SHELL_ENVIRONMENT_CONFIGURATION_FILE=$shell_configuration_file
}

function add_to_shell_configuration_file_if_not_present() {
    local line_to_add="$@"
    if [[ ! $(grep "$line_to_add" $SHELL_ENVIRONMENT_CONFIGURATION_FILE) ]]; then
        echo "$line_to_add" >> $SHELL_ENVIRONMENT_CONFIGURATION_FILE
    fi
}

function add_to_path_in_shell_environment_configuration_file_if_not_present() {
    local new_path_element="$@"
    add_to_shell_configuration_file_if_not_present "PATH=\"$new_path_element:\$PATH\""
}

function check_install_homebrew() {    
    if [[ ! $(which brew) ]]; then
        echo "Installing homebrew... "
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        local homebrew_path
        if [[ $OSTYPE == "linux-gnu" ]]; then
            homebrew_path="/home/linuxbrew/.linuxbrew/bin"
        else 
            exit_with_generic_error_messsage_ending "OS type $OSTYPE"
        fi
        add_to_path_in_shell_environment_configuration_file_if_not_present "$homebrew_path"
        # Need to relog to have PATH var updates take effect
        echo -e "\nLog out and then back in to your computer to complete installation."
    else
        echo "Homebrew already installed"
    fi
    brew update
}

function check_install_pyenv() {
    # https://github.com/pyenv/pyenv#basic-github-checkout
    local shell_configuration_file_for_pyenv
    if [[ $SHELL == "/bin/zsh" ]]; then
        shell_configuration_file_for_pyenv="$HOME/.zshrc"
    elif [[ $SHELL == "/bin/bash" ]]; then
        # lsb-release -i  (then remove distribution id prefix)
        if [[ ]]
        shell_configuration_file_for_pyenv="$HOME/.profile"
    elelse 
        exit_with_generic_error_messsage_ending "Shell type $SHELL"
    fi
    if [[ ! -f $shell_configuration_file ]]; then
        touch $shell_configuration_file
    fi

    if [[ ! $(which pyenv) ]]; then
        brew install pyenv
    fi
}

set_shell_environment_configuration_file

check_install_homebrew

check_install_pyenv
