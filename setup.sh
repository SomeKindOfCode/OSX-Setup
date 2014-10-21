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
# Basic Setup
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

# Homebrew Cask
# http://caskroom.io
if command brew cask 1>/dev/null; then 
	cecho "Homebrew Cask already installed" $green
else
	cecho "Installing Homebrew Cask" $yellow
	brew install caskroom/cask/brew-cask
fi

#############################
# Install Apps
#############################

echo ""
cecho "Now it's time for some Apps..." $yellow

apps=(
	# Utilities
	google-chrome
	bittorrent-sync
	caffeine
	launchbar
	 #carbon-copy-cloner
	macdown
	iterm2
	transmit
	bartender
	 #dropbox
	skype
	soundflower
	# Dev Stuff
	sourcetree
	#coda
	#Gaming
	openemu
	steam
	obs # Open Broadcaster
	# Graphic and Media
	adobe-photoshop-lightroom
	imagealpha
	imageoptim
	plex-media-server
	handbrake
	subler
	vlc
	# Recording
	airserver
)

echo ""
cecho "Do you want to install the following apps?" $cyan

for i in ${apps[@]}; do
	cecho "> ${i}" $magenta
done

echo ""

select yn in "Yes" "No"; do
	case $yn in
		Yes ) 
		cecho "Ok! installing apps..." $yellow
		brew cask install --appdir="/Applications" ${apps[@]} 
		break;;
		No ) break;;
	esac
done

###################
# General UI/UX
###################

echo ""
cecho "Increasing the window resize speed for Cocoa applications" $yellow
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo ""
cecho "Automatically quit printer app once the print jobs complete" $yellow
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################
 
echo ""
cecho "Increasing sound quality for Bluetooth headphones/headsets" $yellow
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo ""
cecho "Do you want to disable auto correction?" $cyan
select yn in "Yes" "No"; do
	case $yn in
		Yes ) 
		echo ""
		cecho "Disabling auto-correct" $yellow
		defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
		break;;
		No ) break;;
	esac
done

###############################################################################
# Screen
###############################################################################
 
echo ""
cecho "Requiring password immediately after sleep or screen saver begins" $yellow
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Finder
###############################################################################
 
echo ""
cecho "Showing icons for hard drives, servers, and removable media on the desktop" $yellow
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo ""
cecho "Do you want to display hidden files in the Finder?" $cyan
select yn in "Yes" "No"; do
  case $yn in
    Yes ) defaults write com.apple.Finder AppleShowAllFiles -bool true
        break;;
    No ) break;;
  esac
done

echo ""
cecho "Showing all filename extensions in Finder by default" $yellow
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
 
echo ""
cecho "Showing status bar in Finder by default" $yellow
defaults write com.apple.finder ShowStatusBar -bool true
 
echo ""
cecho "Allowing text selection in Quick Look/Preview in Finder by default" $yellow
defaults write com.apple.finder QLEnableTextSelection -bool true

echo ""
cecho "Disabling the warning when changing a file extension" $yellow
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
cecho "Use column view in all Finder windows by default" $yellow
defaults write com.apple.finder FXPreferredViewStyle Clmv
 
echo ""
cecho "Avoiding the creation of .DS_Store files on network volumes" $yellow
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
 
echo ""
cecho "Disabling disk image verification" $yellow
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
 
###############################################################################
# Dock & Mission Control
###############################################################################

echo ""
cecho "Speeding up Mission Control animations and grouping windows by application" $yellow
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

###############################################################################
# Safari & WebKit
###############################################################################

echo ""
cecho "Enabling the Develop menu and the Web Inspector in Safari" $yellow
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
cecho "Adding a context menu item for showing the Web Inspector in web views" $yellow
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Time Machine
###############################################################################
 
echo ""
cecho "Preventing Time Machine from prompting to use new hard drives as backup volume" $yellow
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Personal Additions
###############################################################################

echo ""
cecho "Do you want to disable the sleep image?" $cyan
cecho "This will save disk space, but you wont be able to continue work if your battery dies and have to do a full reboot" $magenta
select yn in "Yes" "No"; do
  case $yn in
    Yes ) 
        echo ""
        echo "Remove the sleep image file to save disk space"
        sudo rm /Private/var/vm/sleepimage
        echo "creating a zero-byte file instead"
        sudo touch /Private/var/vm/sleepimage
        echo "and make sure it can't be rewritten"
        sudo chflags uchg /Private/var/vm/sleepimage
        break;;
    No ) break;;
  esac
done

echo ""
cecho "Done! Have fun!" $green
