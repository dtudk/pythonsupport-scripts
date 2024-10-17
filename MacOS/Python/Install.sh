
_prefix="PYS:"

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


echo "$_prefix Python installation"

# Check for homebrew
# if not installed call homebrew installation script
if ! command -v brew > /dev/null; then
  echo "$_prefix Homebrew is not installed. Installing Homebrew..."
  echo "$_prefix Installing from $url_ps/Homebrew/Install.sh"
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

    # Store conda info --base output in a variable
    conda_info_base=$(conda info --base 2> /dev/null)

    # checks for homebrew installations 
    if [[ "$conda_info_base" == *"/Caskroom/miniconda"* ]]; then
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

    if [[ "$conda_info_base" == *"/Caskroom/anaconda"* ]]; then
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
    if [[ -n "$conda_info_base" && "$conda_info_base" != *"/Caskroom/"* ]]; then
        echo "Existing ordinary Conda installation detected at $conda_info_base"
        get_user_confirmation
        if [ "$confirm" = "yes" ]; then
            echo "Uninstalling existing Conda installation..."
            conda init --reverse --all
            # Remove the directory that contains 'base'
            conda_install_dir=$(dirname "$conda_info_base")
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

echo "$_prefix Initialising conda..."
conda init bash 
[ $? -ne 0 ] && exit_message

conda init zsh
[ $? -ne 0 ] && exit_message

# need to restart terminal to activate conda
# restart terminal and continue
# conda puts its source stuff in the bashrc file
[ -e ~/.bashrc ] && source ~/.bashrc

echo "$_prefix Showing where it is installed:"
conda info --base
[ $? -ne 0 ] && exit_message

hash -r 
clear -x

echo "$_prefix Removing defaults channel (due to licensing problems)"
conda config --remove channels defaults
conda config --add channels conda-forge
# Forcefully try to always use conda-forge
conda config --set channel_priority strict

echo "$_prefix Ensuring Python version ${_py_version}..."
conda install python=${_py_version} -y
[ $? -ne 0 ] && exit_message
clear -x 


echo "$_prefix Installing packages..."
conda install dtumathtools pandas scipy statsmodels uncertainties -y
[ $? -ne 0 ] && exit_message
clear -x

echo "$_prefix Changing channel priority back to flexible..."
conda config --set channel_priority flexible
[ $? -ne 0 ] && exit_message
clear -x


echo ""
echo "$_prefix Installed conda and related packages for 1st year at DTU!"
