printf "\n#### BEGIN CONFIG : Misc\n\n"

sed -i -e 's/^%wheel/# %wheel/' -e 's/^# %wheel/%wheel/' /etc/sudoers

printf "\n#### FINISHED CONFIG : Misc\n\n"
