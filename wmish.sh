#!/bin/bash

# Obrigatory
script_dependencies(){
    sudo apt update
    sudo apt install whiptail
}
script_dependencies

version="0.0.1-20190520"
## Check variables
#WM
wmish_backtitle="Window Manager Installer in Shell v$version"
wm_bspwm_checked=OFF

#BAR
bar_lemonbar_checked=OFF
bar_polybar_checked=OFF

#LEMONBAR_CONFIG
lemon_cfg_default_checked=ON
lemon_cfg_folder_checked=OFF
lemon_cfg_example_checked=OFF
lemon_cfg_export_checked=OFF

#POLYBAR_CONFIG
polybar_cfg_alsa_checked=OFF
polybar_cfg_pulseaudio_checked=OFF
polybar_cfg_network_checked=OFF
polybar_cfg_mpd_checked=OFF
polybar_cfg_git_checked=OFF
polybar_cfg_default_checked=ON
polybar_cfg_nerdfont_checked=OFF
polybar_cfg_launcher_checked=OFF

#Display Manager
dm_lightdm_checked=OFF
dm_xinit_checked=OFF

#LightDM Configuration
lightdm_cfg_bspwmdesktop_checked=ON

#Xinit Configuration
xinit_cfg_sxhkd_checked=ON
xinit_cfg_bspwm_checked=ON

#Additional Pkackages
additional_pkgs_curl_checked=OFF
additional_pkgs_wget_checked=OFF

#
bar_choosed_cfg=""

## MENU
menu_window=welcome


## INSTALLERS
#bspwm
bspwm_dependencies="git gcc make xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev"
bspwm_link="https://github.com/baskerville/bspwm.git"
#sxhkd
sxhkd_link="https://github.com/baskerville/sxhkd.git"

#LemonBar
lemonbar_link="https://github.com/LemonBoy/bar.git"
lemonbar_dependencies="xdo sutils xtitle"

#Polybar
polybar_link="https://github.com/polybar/polybar.git"
polybar_dependencies="build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev"

#nerdfont
nerdfont_link="https://github.com/ryanoasis/nerd-fonts.git"

OS=$(lsb_release -si)

## Menu loop
case $OS in
    Debian|Ubuntu)
        menu(){
            while : ; do
                case "$menu_window" in
                    welcome)
                        menu_window=menu
                        whiptail --backtitle "${wmish_backtitle}" \
                            --msgbox 'Caution! this script is going to install packages and configurations files in your PC. So... take care!' 0 0
                        ;;
                    menu)
                        echo "$wm"
                        previous=welcome
                        menu=$( whiptail --fb \
                                --backtitle "${wmish_backtitle}" \
                                --menu 'Menu' 0 0 0 \
                                '1' 'Select Window Manager'        \
                                '2' 'Select Bar' \
                                '3' 'Select Display Manager' \
                                '4' 'Additional Packages' \
                                '5' 'Install' \
                                '6' 'EXIT' 3>&2 2>&1 1>&3)
                        if [[ $menu == *"1"* ]]; then
                            menu_window=wm_select
                        elif [[ $menu == *"2"* ]]; then
                            menu_window=bar_select
                        elif [[ $menu == *"3"* ]]; then
                            menu_window=dm_select
                        elif [[ $menu == *"4"* ]]; then
                            menu_window=additional_pkgs
                        elif [[ $menu == *"5"* ]]; then
                            menu_window=list_options
                        elif [[ $menu == *"6"* ]]; then
                            menu_window=quit_alert
                        fi
                        ;;
                    wm_select)
                        menu_window=menu
                        if [[ $wm == *"bspwm"* ]]; then
                            wm_bspwm_checked=ON
                        fi
                        wm=$( whiptail --fb \
                                --backtitle "${wmish_backtitle}" \
                                --radiolist 'Choose the Window Manager' 0 0 0 \
                                'bspwm' 'Binary Space Partitioning Window Manager' ${wm_bspwm_checked} 3>&2 2>&1 1>&3)
                        previous=menu
                        ;;
                    bar_select)
                        menu_window=menu
                        bar=$( whiptail --fb \
                                --backtitle "${wmish_backtitle}" \
                                --radiolist 'Choose the Bar' 0 0 0 \
                                'LemonBar' 'Featherweight lemon-scented bar' ${bar_lemonbar_checked} \
                                'Polybar' 'A fast and easy-to-use status bar' ${bar_polybar_checked} 3>&1 1>&2 2>&3)
                        if [[ $bar == *"LemonBar"* ]]; then
                            bar_lemonbar_checked=ON
                            bar_polybar_checked=OFF
                            menu_window=lemonbar_config
                            bar_choosed_cfg=$lemon_cfg
                        elif [[ $bar == *"Polybar"* ]]; then
                            bar_polybar_checked=ON
                            bar_lemonbar_checked=OFF
                            menu_window=polybar_config
                            bar_choosed_cfg=$polybar_cfg
                        fi
                        ;;
                    lemonbar_config)
                        lemon_cfg=$( whiptail --fb \
                                        --backtitle "${wmish_backtitle}" \
                                        --checklist 'LemonBar Configuration' 0 0 0 \
                                        'default' 'All the alternatives below' ${lemon_cfg_default_checked} \
                                        'folder' 'Create bar folder inside ~/.config/bspwm' ${lemon_cfg_folder_checked} \
                                        'example' 'Copy default example from bspwm' ${lemon_cfg_example_checked} \
                                        'export' 'Export FIFO and link with bspwmrc' ${lemon_cfg_export_checked} 3>&1 1>&2 2>&3)
                        menu_window=menu
                        if [[ $lemon_cfg == *"folder"* ]]; then
                            lemon_cfg_folder_checked=ON;
                        else
                            lemon_cfg_folder_checked=OFF;
                        fi

                        if [[ $lemon_cfg == *"example"* ]]; then
                            lemon_cfg_example_checked=ON;
                        else
                            lemon_cfg_example_checked=OFF;
                        fi

                        if [[ $lemon_cfg == *"export"* ]]; then
                            lemon_cfg_export_checked=ON;
                        else
                            lemon_cfg_export_checked=OFF;
                        fi

                        if [[ $lemon_cfg == *"default"* || -z "$lemon_cfg" ]]; then
                            lemon_cfg_folder_checked=OFF
                            lemon_cfg_example_checked=OFF
                            lemon_cfg_export_checked=OFF
                            lemon_cfg_default_checked=ON
                        else
                            lemon_cfg_default_checked=OFF;
                        fi
                        previous=menu
                        ;;
                    polybar_config)
                        if [[ $polybar_cfg == *"internal/alsa"* ]]; then
                            polybar_cfg_alsa_checked=ON;
                        else
                            polybar_cfg_alsa_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"internal/pulseaudio"* ]]; then
                            polybar_cfg_pulseaudio_checked=ON;
                        else
                            polybar_cfg_pulseaudio_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"internal/network"* ]]; then
                            polybar_cfg_network_checked=ON;
                        else
                            polybar_cfg_network_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"internal/mpd"* ]]; then
                            polybar_cfg_mpd_checked=ON;
                        else
                            polybar_cfg_mpd_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"internal/github"* ]]; then
                            polybar_cfg_git_checked=ON;
                        else
                            polybar_cfg_git_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"font"* ]]; then
                            polybar_cfg_nerdfont_checked=ON;
                        else
                            polybar_cfg_nerdfont_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"launcher"* ]]; then
                            polybar_cfg_launcher_checked=ON;
                        else
                            polybar_cfg_launcher_checked=OFF;
                        fi

                        if [[ $polybar_cfg == *"default"* || -z "$polybar_cfg" ]]; then
                            polybar_cfg_default_checked=ON;
                            polybar_cfg_pulseaudio_checked=OFF;
                            polybar_cfg_mpd_checked=OFF;
                            polybar_cfg_git_checked=OFF;
                            polybar_cfg_launcher_checked=OFF;
                            polybar_cfg_nerdfont_checked=OFF;
                        else
                            polybar_cfg_default_checked=OFF;
                        fi

                        polybar_cfg=$( whiptail --fb \
                                        --backtitle "${wmish_backtitle}" \
                                        --checklist 'Polybar Support CFG' 0 0 0 \
                                        'default' 'pulseaudio, mpd, github, nerd-font, launcher' ${polybar_cfg_default_checked} \
                                        'internal/alsa' 'alsalib' ${polybar_cfg_alsa_checked} \
                                        'internal/pulseaudio' 'libpulse' ${polybar_cfg_pulseaudio_checked} \
                                        'internal/network' 'libn1/libiw' ${polybar_cfg_network_checked} \
                                        'internal/mpd' 'libmpdclient' ${polybar_cfg_mpd_checked} \
                                        'internal/github' 'libcurl' ${polybar_cfg_git_checked} \
                                        'launcher' 'Install launcher script and link with bspwmrc' ${polybar_cfg_launcher_checked} \
                                        'font' 'nerd-font' ${polybar_cfg_nerdfont_checked} 3>&1 1>&2 2>&3)
                        menu_window=menu
                        ;;
                    dm_select)
                        dm=$( whiptail --fb \
                                --backtitle "${wmish_backtitle}" \
                                --radiolist 'Select the Display Manager' 0 0 0 \
                                'lightdm' 'A X display manager' ${dm_lightdm_checked} \
                                'xinit' 'Used to start DE and apps' ${dm_xinit_checked} 3>&1 1>&2 2>&3)
                        previous=menu
                        menu_window=menu
                        if [[ $dm == *"lightdm"* ]]; then
                            dm_lightdm_checked=ON
                            dm_xinit_checked=OFF
                            menu_window=lightdm_config
                        elif [[ $dm == *"xinit"* ]]; then
                            dm_xinit_checked=ON
                            dm_lightdm_checked=OFF
                            menu_window=xinit_config
                        fi
                        ;;
                    lightdm_config)
                        if [[ $lightdm_cfg == *"bspwm.desktop"* ]]; then
                            lightdm_cfg_bspwmdesktop_checked=ON;
                        else
                            lightdm_cfg_bspwmdesktop_checked=OFF;
                        fi

                        lightdm_cfg=$( whiptail --fb \
                                        --separate-output \
                                        --backtitle "${wmish_backtitle}" \
                                        --checklist 'Set the config for LightDM' 0 0 0 \
                                        'bspwm.desktop' 'Copy bspwm.desktop to lightdm(xsessions)' ${lightdm_cfg_bspwmdesktop_checked} 3>&1 1>&2 2>&3)
                        menu_window=menu
                        ;;
                    xinit_config)
                        if [[ $xinit_cfg == *"bspwm"* ]]; then
                            xinit_cfg_bspwm_checked=ON;
                        else
                            xinit_cfg_bspwm_checked=OFF;
                        fi

                        if [[ $xinit_cfg == *"sxhkd"* ]]; then
                            xinit_cfg_sxhkd_checked=ON;
                        else
                            xinit_cfg_sxhkd_checked=OFF;
                        fi

                        xinit_cfg=$( whiptail \
                                        --backtitle "${wmish_backtitle}" \
                                        --checklist 'Set the config for Xinit(xinitrc)' 0 0 0 \
                                        'bspwm' 'Load BSPWM' ${xinit_cfg_bspwm_checked} \
                                        'sxhkd' 'Load SXHKD' ${xinit_cfg_sxhkd_checked} 3>&1 1>&2 2>&3)
                        menu_window=menu
                        previous=dm_select
                        ;;
                    additional_pkgs)
                        if [[ $add_pkgs == *"curl"* ]]; then
                            additional_pkgs_curl_checked=ON;
                            echo "${additional_pkgs_curl_checked}"
                        else
                            additional_pkgs_curl_checked=OFF;
                        fi

                        if [[ $add_pkgs == *"wget"* ]]; then
                            additional_pkgs_wget_checked=ON;
                        else
                            additional_pkgs_wget_checked=OFF;
                        fi
                        add_pkgs=$(whiptail  --fb \
                                    --backtitle "${wmish_backtitle}" \
                                    --checklist 'Add more packages' 0 0 0 \
                                    'curl' 'Library for transferring data with URLs' ${additional_pkgs_curl_checked} \
                                    'wget' 'Package for retrieving files using HTTP, HTTPS, FTP and FTPS' ${additional_pkgs_wget_checked} 3>&1 1>&2 2>&3)
                        previous=menu
                        menu_window=menu
                        
                        ;;
                    list_options)
                        if [[ $bar == *"LemonBar"* ]]; then
                            bar_choosed_cfg=$lemon_cfg
                        else
                            bar_choosed_cfg=$polybar_cfg
                        fi
                        if [[ $dm == *"lightdm"* ]]; then
                            dm_choosed_cfg=$lightdm_cfg
                        else
                            dm_choosed_cfg=$xinit_cfg
                        fi
                        whiptail --fb \
                            --backtitle "${wmish_backtitle}" \
                            --title 'Packages to be installed' \
                            --yesno --yes-button 'Install' --no-button 'Modify Settings' "
            Window Manager: $wm
            Bar: $bar
            Bar Config: $bar_choosed_cfg
            Display Manager: $dm
            DM Settings: $dm_choosed_cfg
            Additional Packages: $add_pkgs
                            " 0 70
                        response=$?
                        previous=menu
                        if [ "$response" -eq 0 ]; then
                            whiptail \
                            --title 'Install Alert' \
                            --yesno --yes-button "Install" --no-button "Back" 'Do you really want to install?' \
                            0 0
                            response=$?
                            previous=menu
                            if [ "$response" -eq 0 ]; then
                                break 4
                            fi
                        else
                            menu_window=menu
                        fi
                        ;;
                    quit_alert)
                        whiptail --fb \
                            --title 'Alert' \
                            --yesno --yes-button "Leave" --no-button "Back" 'Do you really want to leave?\nYour settings will be lost!' \
                            0 0
                        response=$?
                        previous=menu
                        if [ "$response" -eq 0 ]; then
                            exit
                        else
                            menu_window=menu
                        fi
                        ;;
                esac

            previous=$?
            [ $previous -eq 1 ] && menu_window=$previous # cancel
            [ $previous -eq 255 ] && break               # ESC

            done
        }
    ;;
esac
menu

bspwm_clone(){
    git clone ${bspwm_link}
    cd ./bspwm
}

bspwm_installer(){
    mkdir -p ${HOME}/.config/bspwm
    git clone ${bspwm_link}
    cd ./bspwm
    make
    sudo make install
    cp ./examples/bspwmrc ${HOME}/.config/bspwm
    cd ..
}

sxhkd_installer(){
    mkdir -p ${HOME}/.config/sxhkd
    git clone ${sxhkd_link}
    cd ./sxhkd
    make
    sudo make install
    cd .. && cd ./bspwm
    cp ./examples/sxhkdrc ${HOME}/.config/sxhkd
    cd ..
}

lemon_ins_folder(){
    mkdir -p ${HOME}/.config/bspwm/panel
}

lemon_ins_example(){
    cd ./bspwm
    ls -la
    sudo cp ./examples/panel/panel ${HOME}/.config/bspwm/panel
    sudo cp ./examples/panel/panel_colors ${HOME}/.config/bspwm/panel
    sudo cp ./examples/panel/panel_bar ${HOME}/.config/bspwm/panel
    sudo chmod +x ${HOME}/.config/bspwm/panel/panel
    sudo chmod +x ${HOME}/.config/bspwm/panel/panel_colors
    sudo chmod +x ${HOME}/.config/bspwm/panel/panel_bar
    cd ..
}

lemon_ins_export(){
    sudo echo "" >> ${HOME}/.bashrc
    sudo echo export PANEL_FIFO="/tmp/panel-fifo" >> ${HOME}/.bashrc
}

lemon_ins_default(){
    lemon_ins_folder
    lemon_ins_example
    lemon_ins_export
}

lemonbar_installer(){
    #LemonBar Dependencies
    for dep in $lemonbar_dependencies
    do
        echo -e "\nInstalling $dep \n"
        git clone https://github.com/baskerville/$dep.git
        cd ./$dep
        make
        sudo make install
        cd ..
        echo -e "\n$dep Successfully Installed \n"
    done

    if [[ $lemon_cfg == *"folder"* ]]; then
        lemon_ins_folder
    fi
    if [[ $lemon_cfg == *"example"* ]]; then
        lemon_ins_example
    fi
    if [[ $lemon_cfg == *"export"* ]]; then
        lemon_ins_export
    fi
    if [[ $lemon_cfg == *"default"* ]]; then
        lemon_ins_default
    fi
}

polybar_ins_alsa(){
    sudo apt install alsa-oss libasound2-dev
}

polybar_ins_pulseaudio(){
    sudo apt install alsa-oss pulseaudio libpulse-dev
}

polybar_ins_network(){
    sudo apt install libiw-dev libnl-genl-3-dev
}

polybar_ins_mpd(){
    sudo apt install mpd libmpdclient-dev
}

polybar_ins_github(){
    sudo apt install libcurl4-openssl-dev
}

polybar_ins_launcher(){
    mkdir -p ${HOME}/.config/polybar
    ls -la
    cp ../src/launch.sh ${HOME}/.config/polybar
    sudo chmod +x ${HOME}/.config/polybar/launch.sh
    echo '$HOME/.config/polybar/launch.sh' >> ${HOME}/.config/bspwm/bspwmrc
}

polybar_ins_nerdfont(){
    git clone ${nerdfont_link}
    cd ./nerd-fonts
    sudo chmod +x ./install.sh
    ./install.sh
    sudo dpkg-reconfigure fontconfig-config
    sudo fc-cache -fv
    cd ..
}

polybar_ins_default(){
    polybar_ins_pulseaudio
    polybar_ins_mpd
    polybar_ins_github
    polybar_ins_launcher
    polybar_ins_nerdfont
}

polybar_installer(){
    sudo apt install ${polybar_dependencies}
    if [[ $polybar_cfg == *"internal/alsa"* ]]; then
        polybar_ins_alsa
    fi
    if [[ $polybar_cfg == *"internal/pulseaudio"* ]]; then
        polybar_ins_pulseaudio
    fi
    if [[ $polybar_cfg == *"internal/network"* ]]; then
        polybar_ins_network
    fi
    if [[ $polybar_cfg == *"internal/mpd"* ]]; then
        polybar_ins_mpd
    fi
    if [[ $polybar_cfg == *"internal/github"* ]]; then
        polybar_ins_github
    fi
    if [[ $polybar_cfg == *"font"* ]]; then
        polybar_ins_nerdfont
    fi
    if [[ $polybar_cfg == *"default"* || -z "$polybar_cfg" ]]; then
        polybar_ins_default
    fi
    if [[ $polybar_cfg == *"launcher"* ]]; then
        polybar_ins_launcher
    fi
}

lightdm_enable_function(){
    whiptail --fb \
            --title 'Alert' \
            --yesno --yes-button "Yes" --no-button "No" 'Do you want to enable lightdm service' \
            0 0
    response=$?
    previous=menu
    if [ "$response" -eq 0 ]; then
        sudo systemctl enable lightdm.service
        echo -e "\nLightDM Activated \n"
    else
        break
    fi
}

lightdm_ins_bspwm(){
    bspwm_clone
    sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions
}

lightdm_installer(){
    sudo apt-get install lightdm
}

xinit_cfg_bspwm(){
    sudo echo 'exec bspwm' >> ${HOME}/.xinitrc
}

xinit_cfg_sxhkd(){
    sudo echo 'sxhkd &' >> ${HOME}/.xinitrc
}

xinit_installer(){
    sudo apt-get install xinit
    if [[ $xinit_cfg == *"sxhkd"* ]]; then
        xinit_cfg_sxhkd
    fi
    if [[ $xinit_cfg == *"bspwm"* ]]; then
        xinit_cfg_bspwm
    fi
}

add_pkgs_ins_wget(){
    sudo apt install wget
}

add_pkgs_ins_curl(){
    sudo apt install curl libcurl4-openssl-dev
}

installer(){
    if [[ $wm == *"bspwm"* ]]; then
        sudo apt-get install ${bspwm_dependencies}
        bspwm_installer
        sxhkd_installer
        echo -e "\nBSPWM Successfully Installed \n"
        sleep 1
    fi

    if [[ $bar == *"LemonBar"* ]]; then
        echo -e "\nInstalling LemonBar \n"
        lemonbar_installer
    elif [[ $bar == *"Polybar"* ]]; then
        echo -e "\nInstalling Polybar \n"
        polybar_installer
    fi

    if [[ $dm == *"lightdm"* ]]; then
        light_installer
        lightdm_enable_function
        echo -e "\nLightDM Successfully Installed \n"
        if [[ $lightdm_cfg == *"bspwm.desktop"* ]]; then
            lightdm_ins_bspwm
        fi
        sleep 1
    elif [[ $dm == *"xinit"* ]]; then
        xinit_installer
    fi

    if [[ $add_pkgs == *"wget"* ]]; then
        add_pkgs_ins_wget
    fi
    if [[ $add_pkgs == *"curl"* ]]; then
        add_pkgs_ins_curl
    fi

}

finished(){
    whiptail --fb \
            --title 'Finished' \
            --yesno --yes-button "Exit" --no-button "Menu" 'Installation finished, you want to exit or back to the menu?' \
            0 0
    response=$?
    if [ "$response" -eq 0 ]; then
        exit
    else
        menu_window=menu
        menu
    fi
}

main () {
    if [ -d "./build" ]; then
        cd ./build
    else
        mkdir ./build
        cd ./build
    fi
    installer
    finished
}

main
