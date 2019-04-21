#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys

from PyQt5.QtCore import QObject, QUrl, Qt, pyqtSlot, pyqtSignal, pyqtProperty
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView
from PyQt5.QtQml import qmlRegisterType

#from PyQt5.QtChart import QChart, QChartView, QLineSeries

#pyrcc5 -o images_rc.py images.qrc
import images_rc

#pyrcc5 -o components_rc.py components.qrc
#import components_rc

#pyrcc5 -o qml_rc.py qml.qrc
#import qml_rc

if __name__ == '__main__':

    app_path = os.path.abspath(os.path.dirname(sys.argv[0]))
    sys.path.insert(1,os.path.join( os.path.dirname(os.path.dirname(os.path.abspath(__file__))),'Components'))

    os.environ['QT_QUICK_CONTROLS_CONF'] = '/etc/qml4cop/qtquickcontrols2.conf'
    os.environ['XDG_CONFIG_HOME'] = '/etc'
    os.environ['QT_IM_MODULE'] = 'qtvirtualkeyboard'

    app = QGuiApplication(sys.argv)
    app.setOrganizationDomain("qml4cop")
    app.setOrganizationName("qml4cop")
    app.setApplicationName("qml4cop")
    app.setApplicationVersion("0.21.0")


    view = QQuickView()
    view.engine().quit.connect(app.quit)

#    view.setSource(QUrl('qrc:///MainPage.qml'))
    view.setSource(QUrl('MainPage.qml'))


    view.show()

    sys.exit(app.exec_())
