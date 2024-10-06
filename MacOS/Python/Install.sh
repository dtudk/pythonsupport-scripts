# checks for environmental variables for remote and branch 
if [ -z "$REMOTE_PS" ]; then
  REMOTE_PS="dtudk/pythonsupport-scripts"
fi
if [ -z "$BRANCH_PS" ]; then
  BRANCH_PS="main"
fi

export REMOTE_PS
export BRANCH_PS

# set URL
url_ps="https://raw.githubusercontent.com/$REMOTE_PS/$BRANCH_PS/MacOS"


echo "Python installation"

# Check for homebrew
# if not installed call homebrew installation script
if ! command -v brew > /dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."
  echo "Installing from $url_ps/Homebrew/Install.sh"
  /bin/bash -c "$(curl -fsSL $url_ps/Homebrew/Install.sh)"

  # The above will install everything in a subshell.
  # So just to be sure we have it on the path
  [ -e ~/.bash_profile ] && source ~/.bash_profile

  # update binary locations 
  hash -r 
fi


# Error function 
# Print error message, contact information and exits script
exit_message () {
  echo ""
  echo "Oh no! Something went wrong"
  echo ""
  echo "Please visit the following web page:"
  echo ""
  echo "   https://pythonsupport.dtu.dk/install/macos/automated-error.html"
  echo ""
  echo "or contact the Python Support Team:"
  echo ""
  echo "   pythonsupport@dtu.dk"
  echo ""
  echo "Or visit us during our office hours"
  open https://pythonsupport.dtu.dk/install/macos/automated-error.html
  exit 0
}



if [ -z "$PYTHON_VERSION_PS" ]; then
    PYTHON_VERSION_PS="3.11"
fi

_py_version=$PYTHON_VERSION_PS

# Install miniconda
# Check if miniconda is installed

echo "Checking for Miniconda or Anaconda installation..."
if conda --version > /dev/null; then
    echo "Miniconda or Anaconda is already installed."

    # function to handle user confirmation
    get_user_confirmation() {
        read -p "Do you want to uninstall it? (yes/no): " confirm
        confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
        if [[ "$confirm" != "yes" && "$confirm" != "no" ]]; then
            echo "Please answer yes or no."
            get_user_confirmation
        fi
    }

    # checks for homebrew installations 
    if [[ $(conda info --base 2> /dev/null) == *"/Caskroom/miniconda"* ]]; then
        echo "Existing Miniconda installation through homebrew detected."
        get_user_confirmation
        if [ "$confirm" = "yes" ]; then
            echo "Uninstalling existing Homebrew Miniconda installation..."
            conda init --reverse --all
            brew uninstall --cask miniconda
            echo "Existing Miniconda installation has been removed."
        else
            echo "Installation aborted. The script cannot proceed without removing the existing Miniconda installation."
            exit 0
        fi
    fi

    if [[ $(conda info --base 2> /dev/null) == *"/Caskroom/anaconda"* ]]; then
        echo "Existing Anaconda installation through homebrew detected."
        get_user_confirmation
        if [ "$confirm" = "yes" ]; then
            echo "Uninstalling existing Homebrew Anaconda installation..."
            conda init --reverse --all
            brew uninstall --cask anaconda
            echo "Existing Anaconda installation has been removed."
        else
            echo "Installation aborted. The script cannot proceed without removing the existing Anaconda installation."
            exit 0
        fi
    fi
    # Checks for ordinary installations
    conda_path=$(conda info --base 2> /dev/null)
    if [[ -n "$conda_path" && "$conda_path" != *"/Caskroom/"* ]]; then
        echo "Existing ordinary Conda installation detected at $conda_path"
        get_user_confirmation
        if [ "$confirm" = "yes" ]; then
            echo "Uninstalling existing Conda installation..."
            conda init --reverse --all
            # Remove the directory that contains 'base'
            conda_install_dir=$(dirname "$conda_path")
            sudo rm -rf "$conda_install_dir"
            echo "Existing Conda installation has been removed."
        else
            echo "Installation aborted. The script cannot proceed without removing the existing Conda installation."
            exit 0
        fi
    fi

# Call installation script again 
/bin/bash -c "$(curl -fsSL $url_ps/Python/Install.sh)"
fi

echo "Installing Miniconda..."
brew install --cask miniconda 
[ $? -ne 0 ] && exit_message
clear -x


echo "Initialising conda..."
conda init bash 
[ $? -ne 0 ] && exit_message

conda init zsh
[ $? -ne 0 ] && exit_message

# need to restart terminal to activate conda
# restart terminal and continue
# conda puts its source stuff in the bashrc file
[ -e ~/.bashrc ] && source ~/.bashrc

hash -r 
clear -x

echo "Removing defaults channel (due to licensing problems)"
conda config --add channels conda-forge
conda config --remove channels defaults


echo "Ensuring Python version ${_py_version}..."
conda install python=${_py_version} -y
[ $? -ne 0 ] && exit_message
clear -x 


echo "Installing packages..."
conda install dtumathtools pandas scipy statsmodels uncertainties -y
[ $? -ne 0 ] && exit_message
clear -x

echo ""
echo "Installed conda and related packages for 1st year at DTU!"
