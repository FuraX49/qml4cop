project(qml4cop NONE)

cmake_minimum_required(VERSION 3.6)


include(GNUInstallDirs)
find_package(PythonInterp 3.6.0 REQUIRED)


# Parse version from pyqt file

file(STRINGS "qml4cop.py" VERSION_LINE LIMIT_COUNT 1   REGEX "app.setApplicationVersion")
string(REGEX MATCH "[0-9]+\\.[0-9]+(\\.[0-9]+)?" PY_VERSION ${VERSION_LINE})
STRING(REGEX REPLACE "^([0-9]+)\\..*" "\\1" PY_VERSION_MAJOR ${PY_VERSION})
STRING(REGEX REPLACE "^[0-9]+\\.([0-9]+).*" "\\1" PY_VERSION_MINOR ${PY_VERSION})
STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" PY_VERSION_PATCH ${PY_VERSION})

set(CPACK_PACKAGE_VERSION_MAJOR ${PY_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PY_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PY_VERSION_PATCH})


set(CPACK_PACKAGE_VENDOR "Thing-Printer")
set(CPACK_PACKAGE_CONTACT "FuraX49 <furax44@free.fr>")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "QML for OctoPint, EGLFS TouchScreen interface client for OctoPrint.")
set(CPACK_GENERATOR "DEB")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "all")
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}_${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}")


# ************* DEBUG ****************
set(CPACK_DEBIAN_PACKAGE_DEBUG ON)

set(DEB_DEPENDS
    "python3 (>= 3.6.0)"
    "python3-pyqt5 (>= 5.9.5)"
    "python3-pyqt5.qtopengl "
    "python3-pyqt5.qtquick "
    "python3-pyqt5.qtsvg "
    "qtvirtualkeyboard-plugin"
    "pyqt5-dev-tools"
    "qmlscene"
    "qml-module-qtgraphicaleffects "
    "qml-module-qt-labs-folderlistmodel"
    "qml-module-qt-labs-settings"
    "qml-module-qtqml-models2"
    "qml-module-qtquick2"
    "qml-module-qtquick-controls2"
    "qml-module-qtquick-layouts"
    "qml-module-qtquick-templates2"
    "qml-module-qtquick-virtualkeyboard"
    "qml-module-qtquick-window2"
    "qml-module-qtwebsockets"
)
string(REPLACE ";" "," DEB_DEPENDS "${DEB_DEPENDS}")
set(CPACK_DEBIAN_PACKAGE_DEPENDS ${DEB_DEPENDS})


# ************************** APPLICATION **************************
install(FILES "qml4cop.py" "MainPage.qml" "Print.qml" "Files.qml"  "Jog.qml" "Terminal.qml" "Configs.qml" "qml.qrc" "components.qrc" "images.qrc"
    DESTINATION "/opt/qml4cop"
)

install(DIRECTORY Images/
    DESTINATION "/opt/qml4cop/Images"
)

install(DIRECTORY Components/
    DESTINATION "/opt/qml4cop/Components"
)
# ************************** SCRIPTS **************************
if(EXISTS "/lib/systemd/system")
    install(FILES scripts/qml4cop.service
      DESTINATION "/lib/systemd/system"
      PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
    )
    install(FILES scripts/qml4cop
      DESTINATION "/usr/local/bin"
      PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ WORLD_READ
    )

endif()

# ************************** CONFIGS **************************
install(FILES configs/qml4cop.conf
      DESTINATION "/etc/qml4cop"
      PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ GROUP_WRITE WORLD_READ
)
install(FILES configs/qtquickcontrols2.conf
      DESTINATION "/etc/qml4cop"
      PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ GROUP_WRITE WORLD_READ
)

# **************************  debian control files **************************

set( CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/postinst;${CMAKE_CURRENT_SOURCE_DIR}/DEBIAN/prerm" )



include(CPack)
