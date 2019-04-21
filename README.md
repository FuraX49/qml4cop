# qml4cop
Allows you to control your 3D Printer with any   TouchScreen.

But in Qt QML/Python3   client  of  Octoprint,  and can run without X11 in EGLFS.

![Print](/home/furax/Images/qml4cop/Print.png)

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

Edit /usr/local/bin/qml4cop 

- adjust screen resolution.
- adjust screen size  in mm.  
- QT_QPA_PLATFORM=eglfs, linuxfb, diirectfb, wayland, xcb    (see https://doc.qt.io/qt-5/embedded-linux.html)
- QT_QPA_EGLFS_INTEGRATION=none ( eglfs_brcm for PI3)



 Edit /etc/qml4cop/qml4cop.conf 

