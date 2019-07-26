#!/bin/bash


#THIS SOFTWARE IS PROVIDED UNDER MIT LICENSE. A COPY IS AVALIABLE AT https://raw.githubusercontent.com/MinecraftDesktopOnPi/MConPi2019/master/LICENSE
# A script to install minecraft on pi (for the lazy lads)
# Thanks to rpiMike on the raspberry pi forums for making this possible


# SNIPPED FROM raspi-config  https://github.com/RPi-Distro/raspi-config UNDER MIT LICENSE
WT_HEIGHT=17
WT_WIDTH=$(tput cols)



# get pi version 
# SNIPPED BUT CHANGED FROM raspi-config  https://github.com/RPi-Distro/raspi-config UNDER MIT LICENSE

pione() {
   if grep -q "^Revision\s*:\s*00[0-9a-fA-F][0-9a-fA-F]$" /proc/cpuinfo; then
      return 0
   elif grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[0-36][0-9a-fA-F]$" /proc/cpuinfo ; then
      return 0
   else
      return 1
   fi
}
pitwo() {
   grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]04[0-9a-fA-F]$" /proc/cpuinfo
   return $?
}
pizero() {
   grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[9cC][0-9a-fA-F]$" /proc/cpuinfo
   return $?
}
pifour() {
   grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]11[0-9a-fA-F]$" /proc/cpuinfo
   return $?
}
piver() {
   if pione; then
      Pi=1
   elif pitwo; then
      Pi=2
   elif pizero; then
      Pi=0
   elif pifour; then
      Pi=4
   else
      Pi=3
   fi
}

# SNIPPED FROM raspi-config  https://github.com/RPi-Distro/raspi-config UNDER MIT LICENSE
if [ -z "$WT_WIDTH" ] || [ "$WT_WIDTH" -lt 60 ]; then
  WT_WIDTH=80
fi
if [ "$WT_WIDTH" -gt 178 ]; then
  WT_WIDTH=120
fi

WT_MENU_HEIGHT=$(($WT_HEIGHT-7))




update() {
	# Updates system packages
	sudo apt -q update && sudo apt -y upgrade
}

gldrivers() {
	if [ $Pi -eq 3 ]; then 
		# Turns GL drivers on
		sudo sed /boot/config.txt -i -e "s/^dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/g"
		sudo sed /boot/config.txt -i -e "s/^#dtoverlay=vc4-kms-v3d/dtoverlay=vc4-fkms-v3d/g"
	fi
}

stopifcannothandle() {
	# Stops if your Pi cannot handle it
	if [ $Pi -lt 3 ];  then
		exit
	fi
} 




setupmc1() {
	# Install rpiMike's setupMC1 script
	# I DO NOT CLAIM CREDIT FOR THE SCRIPT THAT WILL BE DOWNLOADED. IT IS NOT MY WORK AND I CLAIM NO PART IN IT.
	mkdir ~/Minecraft
	cd ~/Minecraft
	wget https://www.dropbox.com/s/4irv50ow07yxn65/setupMC1.sh
	chmod +x setupMC1.sh
	./setupMC1.sh
}






mcinstallbaseassets() {
	whiptail --msgbox "When the Minecraft launcher loads in a minute, please:\n
	Login with email and password\n
	Click 'edit profile' and select use profile - 'release 1.12.2', then 'save profile\n
	Click Play\n
	You will get an error\n
	Close launcher\n" $WT_HEIGHT $WT_WIDTH 
	cd ~/Minecraft
	java -jar Minecraft.jar && sleep 5 && echo ^C
}




installoptifine() {
	whiptail --msgbox "Please click Install when the OptiFine installer loads" --title "Minecraft Installer Tool" $WT_HEIGHT $WT_WIDTH 
	cd ~/Minecraft
	java -jar OptiFine_1.12.2_HD_U_E3.jar
}










mcinstalloptifineassets() {
	whiptail --msgbox "When the Minecraft launcher loads in a minute, please:\n
	Click 'edit profile' and select use profile - 'Optifine', then 'save profile.\n
	Click Play.\n
	You will get an error.\n
	Close launcher.\n" $WT_HEIGHT $WT_WIDTH --title "Minecraft Installer Tool"
	cd ~/Minecraft
	java -jar Minecraft.jar
}



getcredentials() {
	  EMAIL=$(whiptail --inputbox "Please enter your minecraft email (NOT USERNAME)." $WT_HEIGHT $WT_WIDTH --title "Minecraft Installer Tool" 3>&1 1>&2 2>&3)

	  USERNAME=$(whiptail --inputbox "Please enter your minecraft username (NOT EMAIL)." $WT_HEIGHT $WT_WIDTH  --title "Minecraft Installer Tool" 3>&1 1>&2 2>&3)

	  PASSWORD=$(whiptail --passwordbox "Please enter your minecraft password." $WT_HEIGHT $WT_WIDTH  --title "Minecraft Installer Tool" 3>&1 1>&2 2>&3)

}


changecredentials() {
	cd ~/Minecraft
	sed -n "s/LOGIN=abc@bbb.ccc/LOGIN=$EMAIL/" runMC1_12_2_OptifineE3.sh
	sed -n "s/USERNAME=abcdefghi/USERNAME=$USERNAME/" runMC1_12_2_OptifineE3.sh
	sed -n "s/PASSWORD=xxxxxxxx/PASSWORD=$PASSWORD/" runMC1_12_2_OptifineE3.sh
}




pione
pitwo
pizero
pifour

piver

echo "Your Pi will now update. Please wait"
update

gldrivers

stopifcannothandle

setupmc1

mcinstallbaseassets

installoptifine

mcinstalloptifineassets

getcredentials

changecredentials

