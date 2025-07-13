#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download
cd ..
echo Makking the main haxelib and setuping folder in same time..
mkdir ~/haxelib && haxelib setup ~/haxelib
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib --quiet install flixel 5.6.1
haxelib --quiet install flixel-addons 3.2.2
haxelib --quiet install flixel-tools 1.5.1
haxelib --quiet install hscript-iris 1.1.3
haxelib --quiet install tjson 1.4.0
haxelib --quiet install hxdiscord_rpc 1.2.4
haxelib --quiet install hxvlc 2.0.1 --skip-dependencies
haxelib --quiet install lime 8.1.2
haxelib --quiet install openfl 9.3.3
haxelib --quiet git flxanimate https://github.com/Dot-Stuff/flxanimate 768740a56b26aa0c072720e0d1236b94afe68e3e
haxelib --quiet git linc_luajit https://github.com/superpowers04/linc_luajit 1906c4a96f6bb6df66562b3f24c62f4c5bba14a7
echo Finished!
