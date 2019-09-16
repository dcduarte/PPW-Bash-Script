#!/bin/bash


#Main menu function
mainmenu(){
#Create the menu using whiptail
OPTION=$(whiptail --title "Test Menu Dialog" --menu "Choose your option" 15 60 6 \
"1" "Option 1" \
"2" "Option 2" \
"3" "Option 3" \
"4" "Option 4" \
"5" "Option 5" \
"6" "Option 6"  3>&1 1>&2 2>&3)

	case $OPTION in
		1)
			#Get the password to use on sudo commands
			PASSWORD=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
			status=$?			
			if [ $status = 0 ]; then
				#Update the system
				sudo -S <<< $PASSWORD pacman -Syu
				#Ask the user if they want to activate the firewall
				if (whiptail --title "Firewall" --yesno "Updates installed. Do you want to activate the firewall?" 10 60) then
					#Activate the firewall and turn logging off
					sudo -S <<< $PASSWORD ufw enable
					sudo -S <<< $PASSWORD ufw logging off
					whiptail --title "Activation sucessfull" --msgbox "Firewall is activated and logging is off. Press ok to continue" 10 60
					#Go back to the main menu after pressing ok
					mainmenu
				else
					#Go back to the main menu if the user presses no on the firewall question
					mainmenu
				fi		
			else
				mainmenu			
			fi
			;;
		2)
			#Display the contents of rootfs-pkgs.txt file on a whiptail text box
			whiptail --title "Rootfs" --textbox --scrolltext /rootfs-pkgs.txt 20 60
			mainmenu

			;;
		3)	
			#Create my-utils.txt file on the users desktop
			touch /home/$USER/Desktop/my-utils.txt
			#Search for the word utils on rootfs-pkgs and desktopfs-pkgs.txt and write the results in my-utils.txt
			grep utils /rootfs-pkgs.txt > /home/$USER/Desktop/my-utils.txt
			grep utils /desktopfs-pkgs.txt > /home/$USER/Desktop/my-utils.txt
			#Display the content of my-utils.txt on a whiptail text box
			whiptail --title "My-Utils" --textbox --scrolltext /home/$USER/Desktop/my-utils.txt 20 60
			mainmenu
			;;
		4)
			#Get the password to use on sudo commands
			PASSWORD=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
			#Ask the user for confirmation to install the games
			if (whiptail --title "Games" --yesno "Are you sure you want to install Extreme Tux Racer and SuperTux 2" 10 60) then	
					#Install the games
					sudo -S <<<$PASSWORD sudo pacman -S --noconfirm extremetuxracer supertux	
					#Message to tell the user the games were installed
					whiptail --title "Installation Sucessful" --msgbox "Installation Sucessfull. Press ok to continue" 10 60
					mainmenu
				
			else
				#Quickly return to the main menu if the user accidentally clicked this option
				mainmenu
			fi	
			;;			
		5)
			#Call the option 5 sub menu
			option5
		;;
		6)
			#Call the exit sub menu
			exitmenu
		;;
		*)

			whiptail --title "Invalid Option" --msgbox "Invalid Option. Press ok to go back to the main menu" 10 60
			mainmenu			
			;;
esac
}

#Option 5 sub menu
option5(){
#Menu for the user to select which game to play
GAME=$(whiptail --title "Games" --menu "What game do you want to play" 15 60 3 \
			"1" "Extreme Tux Racer" \
			"2" "SuperTux2" \
			"3" "Back to the main menu" 3>&1 1>&2 2>&3)
			
			case $GAME in
			1)
				#Start extreme tux racer (did not open in video because it runs full-screen and the software didn't capture it)
				etr
				#Return to the sub menu
				option5
				;;
			2)
				#Start SuperTux 2
				supertux2
				#Return to the sub menu
				option5
				;;
			3)
				#Return to the Main Menu
				mainmenu
				;;
			esac
}

#Exit sub menu
exitmenu(){

if (whiptail --title "Exit" --yesno "Do you really want to exit?" 10 60) then
	#Exit the script if user pressed yes
	exit
else
	#GO back to the main menu if user presses no
	mainmenu
fi
}
#Call the main menu at the start of the script
mainmenu