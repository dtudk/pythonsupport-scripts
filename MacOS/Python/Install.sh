
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


Echo "get's to python installation"
# Check for homebrew
# if not installed call homebrew installation script
if ! command -v brew > /dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."
  echo "installing from $url_ps/Homebrew/Install.sh"
  /bin/bash -c "$(curl -fsSL $url_ps/Homebrew/Install.sh)"
fi


# Error function 
# Print error message, contact information and exits script
exit_message () {
    echo ""
    echo "Oh no! Something went wrong"
    echo ""
    echo "Please visit the following web page:"
    echo ""
    echo "https://pythonsupport.dtu.dk/install/macos/automated-error.html"
    echo ""
    echo "or contact the Python Support Team:" 
    echo ""
    echo "  pythonsupport@dtu.dk"
    echo ""
    echo "Or visit us during our office hours"
    open https://pythonsupport.dtu.dk/install/macos/automated-error.html
    exit 1
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
    echo "To proceed with the installation, the existing Conda installation must be removed."
    read -p "Do you want to uninstall it? (Type 'yes' to confirm): " confirm
    if [ "$confirm" = "yes" ]; then
        echo "Uninstalling existing Conda installation..."
        conda init --reverse --all
        cd
        rm -rf ~/anaconda3
        rm -rf ~/miniconda3
        sudo rm -rf /opt/anaconda3
        sudo rm -rf /opt/miniconda3
        echo "Existing Conda installation has been removed."
    else
        echo "Installation aborted. The script cannot proceed without removing the existing Conda installation."
        exit 0
    fi
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

# 'restart' terminal
eval "$($brew_path shellenv)"

hash -r 
clear -x

echo "Removing defaults channel (due to licensing problems)"
conda config --add channels conda-forge
conda config --remove channels defaults


echo "Downgrading python version to ${_py_version}..."
conda install python=${_py_version} -y
[ $? -ne 0 ] && exit_message
clear -x 

# We will not install the Anaconda GUI
# There may be license issues due to DTU being
# a rather big institution. So our installation guides
# Will be pre-cautious here, and remove the defaults channels.

echo "Installing packages..."
conda install dtumathtools pandas scipy statsmodels uncertainties -y
[ $? -ne 0 ] && exit_message
clear -x

