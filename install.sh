#!/bin/bash
clear
if [ $USER != "root" ]; then
    echo "You are not root. Please run this script as root."
    exit 1
fi
release=$(cat /etc/os-release | grep -oP '(?<=^PRETTY_NAME=).*$')
if [ "$release" != '"Debian GNU/Linux 11 (bullseye)"' ]; then
    echo "This script is only intended for fresh installations of Debian 11, you are running $release"
    echo -n "Would you like to continue anyway? (y/N): "
    read continue
    if [ "$continue" = "y" ] || [ "$continue" = "Y" ]; then
        clear
        echo "Continuing anyway..."
    else
        exit 1
    fi
fi

function report() {
  dialog --title "Reporting" --msgbox "Thank you for attempting to use the SmartDisplayPi10s installer. Depending on the error output, you can file a bug at https://github.com/Sid220/smartdisplaypi-10s/issues (i.e actual bug), or rerun it (i.e. network error)." 10 50
}

function aptLog() {
  dialog --title "apt Log" --textbox /var/log/apt/term.log 20 50
  dialog --title "Would you like to continue?" --yesno "Would you like to continue?" 10 50
  if [ $? != 0 ]; then
      report
      exit 1
  else
      clear
  fi
}

apt install -y git dialog
if [ $? != 0 ]; then
    echo "Error installing git and dialog"
    report
    exit 1
fi
dialog --title "Welcome!" --msgbox "Welcome to the SmartDisplayPi10s installer. This will automatically install everything you need." 10 50
dialog --title "Preliminary information" --inputbox "Please enter your NON-ROOT account you plan to view SmartDisplayPi10s in:" 10 50 2> /tmp/username
if [ $? != 0 ]; then
    dialog --title "Error" --msgbox "You did not enter a username. Please run this script again." 10 50
    exit 1
else
    id $(cat /tmp/username)
    if [ $? != 0 ]; then
        dialog --title "Error" --msgbox "You did not enter a valid username. Please run this script again." 10 50
        exit 1
    fi
fi
clear
apt update -y && apt upgrade -y
if [ $? != 0 ]; then
    dialog --title "Error" --yesno "Error updating or upgrading. Would you like to see the log? You must view the log if you wish to continue." 10 50
    if [ $? == 0 ]; then
      aptLog
    else
      report
      exit 1
    fi
fi

git clone https://github.com/Sid220/smartdisplaypi-10s.git /usr/share/smartdisplaypi-10s
if [ $? != 0 ]; then
    dialog --title "Error" --msgbox "Error cloning the repository." 10 50
    report
    exit 1
fi

apt install xserver-xorg-core --no-install-recommends --no-install-suggests -y
if [ $? != 0 ]; then
    dialog --title "Error" --yesno "Error installing xserver-xorg-core. Would you like to see the log? You must view the log if you wish to continue." 10 50
    if [ $? == 0 ]; then
        aptLog
    else
      report
      exit 1
    fi
fi
apt install slim -y
if [ $? != 0 ]; then
    dialog --title "Error" --yesno "Error installing slim DM. Would you like to see the log? You must view the log if you wish to continue." 10 50
    if [ $? == 0 ]; then
        aptLog
    else
      report
        exit 1
    fi
fi

mv /usr/share/smartdisplaypi-10s/assets/slim_NOCURSOR.conf /etc/slim.conf
if [ $? != 0 ]; then
    dialog --title "Error" --yesno "Error moving slim config. Would you like to continue?" 10 50
    if [ $? != 0 ]; then
        report
        exit 1
    else
        clear
    fi
    exit 1
fi
