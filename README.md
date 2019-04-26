# qml4cop (beta)
Another program to control your 3D Printer with any  TouchScreen, but in Qt QML/Python3   client  of  Octoprint,  and can run without X11 in EGLFS.

![](https://github.com/FuraX49/qml4cop/raw/master/ScreenShots/Print.png)



### Installation on Debian/Ubuntu (recommended)

Download the Debian package and install it by : apt-get install ./qml4cop_0.20.2_all.deb



### Install from source

cd /opt

git clone https://github.com/FuraX49/qml4cop

apt install python3 python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtquick \
python3-pyqt5.qtsvg qtvirtualkeyboard-plugin pyqt5-dev-tools qmlscene \
qml-module-qtgraphicaleffects qml-module-qt-labs-folderlistmodel \
qml-module-qt-labs-settings qml-module-qtqml-models2 qml-module-qtquick2 \
qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtquick-templates2 \
qml-module-qtquick-virtualkeyboard qml-module-qtquick-window2 qml-module-qtwebsockets



Copy scripts/qml4cop in /usr/local/bin 

## Configuration



 **You must have OctoPrint 1.3.10 installed with AccessControl Enabled !**

In Octoprint, add user too AccesControl (ex: qtqmlclient)  and generate it a userkey (in change password )

After you can edit /etc/qml4cop/qml4cop.conf  and replace the "MODIFY" .  

For printerProfil  put the identifier not the name !

If you have Umikaze is too slow at connect, increment cnXinterval , the program by default made 10 try  every 10 seconds.

```
[OctoPrint]
apikey=3DA8864D3E3946D5AE8C85280E79945D
printerProfile=_default
url=http://127.0.0.1:5000
userkey=C98C524EC2BD440CA5296B6EE9BC678B
username=qtqmlclient
cnxInterval=10

[Window]
height=600
rotation=0
width=1024

[_default]
bedABS=100
bedPLA=60
extABS=210
extPLA=180
fanNb=2
printerPort=/dev/octoprint_1
```

##  Run

Edit /usr/local/bin/qml4cop 

```
#!/bin/bash
#/usr/local/bin/qml4cop

# ******** QPA Variables *******************
export QT_QPA_EGLFS_HIDECURSOR=1
export QT_QPA_FONTDIR=/usr/share/fonts/truetype/dejavu
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=none

# *********** SCREEN 7" WaveShare *****************
export QT_QPA_EGLFS_PHYSICAL_WIDTH=156
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=84
export QT_QPA_EGLFS_WIDTH=1024
export QT_QPA_EGLFS_HEIGHT=600
export QT_QPA_EGLFS_ROTATION=0

export XDG_RUNTIME_DIR=/tmp/xdg-rtd-${USER}
if  [ ! -d ${XDG_RUNTIME_DIR} ]  ; then
	mkdir -p ${XDG_RUNTIME_DIR}
fi

cd /opt/qml4cop
python3 qml4cop.py 
```





- adjust screen resolution.
- adjust size QT_QPA_EGLFS_PHYSICAL  in mm.  
- QT_QPA_PLATFORM=eglfs  (possible  linuxfb, diirectfb, wayland, xcb    see https://doc.qt.io/qt-5/embedded-linux.html)
- QT_QPA_EGLFS_INTEGRATION=none (  for BB, eglfs_brcm for PI3)



## Packaging

git clone https://github.com/FuraX49/qml4cop

cd qml4cop

mkdir build

cd build

cmake ../

cpack -G DEB

apt-get install ./qml4cop_0.50.1_all.deb

