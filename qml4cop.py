#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys

from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView
from PyQt5.QtCore import QDir, QUrl, QObject
from PyQt5.QtQml import QQmlEngine

#pyrcc5 -o images_rc.py images.qrc
import images_rc

#pyrcc5 -o components_rc.py components.qrc
#import components_rc

#pyrcc5 -o qml_rc.py qml.qrc
#import qml_rc

if __name__ == '__main__':

    os.environ['QT_QUICK_CONTROLS_CONF'] = '/etc/qml4cop/qtquickcontrols2.conf'
    os.environ['XDG_CONFIG_HOME'] = '/etc'
    os.environ['QT_IM_MODULE'] = 'qtvirtualkeyboard'

    app_path = os.path.abspath(os.path.dirname(sys.argv[0]))
    sys.path.insert(1,os.path.join( os.path.dirname(os.path.dirname(os.path.abspath(__file__))),'Components'))


    app = QApplication(sys.argv)
    app.setOrganizationDomain("qml4cop")
    app.setOrganizationName("qml4cop")
    app.setApplicationName("qml4cop")
    app.setApplicationVersion("0.61.0")

    quickview = QQuickView()

    quickview.setSource(QUrl('MainPage.qml'))
    quickview.engine().quit.connect(app.quit)
    quickview.show()
    sys.exit(app.exec_())
