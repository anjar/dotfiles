!/bin/sh
#
#
# Install Oh My Posh.

# Check for Homebrew
if test ! $(which oh-my-posh)
then
  echo "  Installing Oh My Posh for you."
  brew tap jandedobbeleer/oh-my-posh
  brew install oh-my-posh

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

fi

exit 0