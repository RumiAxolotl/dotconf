#!/bin/bash

#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "$COK - yay was located, moving on."
    yay -Suy
else 
    echo -e "$CWR - Yay was NOT located"
    read -n1 -rep $'[\e[1;33mACTION\e[0m] - Would you like to install yay (y,n) ' INSTYAY
    if [[ $INSTYAY == "Y" || $INSTYAY == "y" ]]; then
        git clone https://aur.archlinux.org/yay.git &>> $INSTLOG
        cd yay
        makepkg -si --noconfirm &>> ../$INSTLOG
        cd ..
        
    else
        echo -e "$CER - Yay is required for this script, now exiting"
        exit
    fi
fi

### Install all of the above pacakges ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    yay -R --noconfirm swaylock waybar
    yay -S --noconfirm hyprland polkit-gnome ffmpeg neovim viewnior \
    rofi pavucontrol thunar starship wl-clipboard wf-recorder     \
    swaybg grimblast-git ffmpegthumbnailer tumbler playerctl      \
    noise-suppression-for-voice thunar-archive-plugin kitty       \
    waybar-hyprland wlogout swaylock-effects sddm-git pamixer     \
    nwg-look-bin dunst ttf-firacode-nerd noto-fonts \
    noto-fonts-emoji ttf-nerd-fonts-symbols-common otf-firamono-nerd \
    brightnessctl hyprpicker-git
fi

### Copy Config Files ###
read -n1 -rep 'Would you like to copy config files? (y,n)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R ./dotconf/dunst ~/.config/
    cp -R ./dotconf/hypr ~/.config/
    cp -R ./dotconf/kitty ~/.config/
    cp -R ./dotconf/neofetch ~/.config/
    cp -R ./dotconf/pipewire ~/.config/
    cp -R ./dotconf/rofi ~/.config/
    cp -R ./dotconf/swaylock ~/.config/
    cp -R ./dotconf/waybar ~/.config/
    cp -R ./dotconf/wlogout ~/.config/
    
    # Set some files as exacutable 
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

### Enable SDDM Autologin ###
read -n1 -rep 'Would you like to enable SDDM autologin? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/sddm.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Enable SDDM service...\n"
    sudo systemctl enable sddm
    sleep 3
fi


### Script is done ###
echo -e "Script had completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi