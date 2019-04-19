cmake_minimum_required(VERSION 3.1)


project(qml4cop)


SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "20")
SET(CPACK_PACKAGE_VERSION_PATCH "0")


set(TOP_DIRECTORY ${CMAKE_SOURCE_DIR})
set(BUILD_DIRECTORY ${TOP_DIRECTORY}/build)

set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CPACK_MONOLITHIC_INSTALL ON)

set(CPACK_COMPONENTS_ALL qmlprog scripts configs)
set(CPACK_PACKAGE_DIRECTORY ${BUILD_DIRECTORY})
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_VENDOR "Thing-Printer")
set(CPACK_PACKAGE_NAME "qml4cop")
#set(CPACK_PACKAGE_DESCRIPTION_FILE "${TOP_DIRECTORY}/description")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "QML for OctoPint, EGLFS TouchScreen interface client for OctoPrint.")
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}_${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}")

# ************* DEBUG ****************
set(CPACK_DEBIAN_PACKAGE_DEBUG ON)

set(CPACK_DEB_COMPONENT_INSTALL ON)
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS OFF)
set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "FuraX49 <furax44@free.fr>")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "all")

set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
set(CPACK_DEBIAN_PACKAGE_SECTION "devel")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "python3-sip,python3-pyqt5 python3-pyqt5 (>= 5.9.5),  python3-pyqt5.qtquick, python3-pyqt5.qtserialport , qtvirtualkeyboard-plugin, pyqt5-dev-tools,
qml-module-qtquick2,qml-module-qtquick-controls2,qml-module-qtquick-layouts,qml-module-qt-labs-settings,qml-module-qtwebsockets,qml-module-qt-labs-folderlistmodel,
qml-module-qtquick-templates2,qml-module-qtquick-window2,qml-module-qtqml-models2,qml-module-qtgraphicaleffects,qmlscene")



# ***********************************************************************************
set(COMPONENT_NAME "qmlprog")

install(FILES "qml4cop.py" "MainPage.qml" "Print.qml" "Jog.qml" "Terminal.qml" "Configs.qml"
    COMPONENT "qmlprog"
    DESTINATION "/opt/qml4cop"
    PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ WORLD_READ
)


install(DIRECTORY Images/ 
    COMPONENT "qmlprog"
    DESTINATION "/opt/qml4cop/Images"
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
)

install(DIRECTORY Components/ 
    COMPONENT "qmlprog"
    DESTINATION "/opt/qml4cop/Components"
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
)


# ***********************************************************************************
set(COMPONENT_NAME "scripts")

if(EXISTS "/lib/systemd/system")
    install(FILES scripts/qml4cop.service
      COMPONENT "scripts"
      DESTINATION "/lib/systemd/system"
      PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
    )
    install(FILES scripts/qml4cop
      COMPONENT "scripts"
      DESTINATION "/usr/local/bin"
      PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ WORLD_READ
    )

endif()


# ***********************************************************************************
set(COMPONENT_NAME "configs")

    install(FILES configs/qml4cop.conf
      COMPONENT "configs"
      DESTINATION "/etc/qml4cop"
      PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ GROUP_WRITE WORLD_READ
    )
    install(FILES configs/qtquickcontrols2.conf
      COMPONENT "configs"
      DESTINATION "/etc/qml4cop"
      PERMISSIONS OWNER_EXECUTE OWNER_READ OWNER_WRITE GROUP_EXECUTE GROUP_READ GROUP_WRITE WORLD_READ
    )



include(CPack)


message(STATUS "CPACK_PACKAGE_NAME: ${CPACK_PACKAGE_NAME}")
message(STATUS "BUILD_DIRECTORY: ${BUILD_DIRECTORY}")

