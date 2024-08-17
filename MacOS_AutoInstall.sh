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
url_ps="https://raw.githubusercontent.com/$REMOTE_PS/$BRANCH_PS"

# echo url for debugging
echo "URL set before curling sub-scripts $url_ps"


# runs placeholder 
/bin/bash -c "$(curl -fsSL $url_ps/MacOS_placeholder.sh)"


