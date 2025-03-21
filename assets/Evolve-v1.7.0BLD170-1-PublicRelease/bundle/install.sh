#!/bin/bash
echo "Installs for current user"
rm -r ~/nex/apps/Evolve
mkdir -p ~/nex/apps/Evolve
chmod +x ./data/flutter_assets/assets/fstmod
cp -r ./* ~/nex/apps/Evolve
rm ~/nex/apps/Evolve/install.sh
echo """[Desktop Entry]
Version=1.6
Type=Application
Name=Evolve
Icon=$HOME/nex/apps/Evolve/iconfile.png
Exec=\"$HOME/nex/apps/Evolve/gtkthememanager\"
Comment=Manage and edit GTK Themes
Terminal=false""" >  ~/.local/share/applications/evolve.desktop
echo "Done"
