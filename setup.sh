#!/bin/sh

# This is a mix of 
# https://gist.github.com/brandonb927/3195465
# which was flavored by 
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# with some sprinkles added by me
# - @CBeloch

# Set the colours you can use
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
 
#  Reset text attributes to normal + without clearing screen.
alias Reset="tput sgr0"
 
# Color-echo.
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}"
  Reset # Reset to normal.
  return
}

# Ask for the administrator password upfront
#sudo -v
 
# Keep-alive: update existing `sudo` time stamp until script has finished
#while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Basic Setup Check
###############################################################################


# Homebrew
# http://brew.sh
if hash brew 2>/dev/null; then
	cecho "Homebrew already installed" $green
else
	cecho "Installing Homebrew" $yellow
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew doctor
fi

cecho "Updating Homebrew" $yellow
#brew update

if command brew cask 1>/dev/null; then 
	cecho "Homebrew Cask already installed" $green
else
	cecho "Installing Homebrew Cask" $yellow
	brew install caskroom/cask/brew-cask
fi