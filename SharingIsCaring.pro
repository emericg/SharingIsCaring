TARGET  = SharingIsCaring

VERSION = 1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

CONFIG += c++11
QT     += core qml quickcontrols2 svg

android { QT += androidextras }
ios { QT += gui-private }
linux:!android { QT += dbus }

# Validate Qt version
!versionAtLeast(QT_VERSION, 5.12) : error("You need at least Qt version 5.12 for $${TARGET}")
!versionAtMost(QT_VERSION, 6.0) : error("You can't use Qt 6.0+ for $${TARGET}")

# Project features #############################################################

# Use Qt Quick compiler
ios | android { CONFIG += qtquickcompiler }

win32 { DEFINES += _USE_MATH_DEFINES }

# MobileUI for mobile OS
include(src/thirdparty/MobileUI/MobileUI.pri)

# MobileSharing for mobile OS
include(src/thirdparty/MobileSharing/MobileSharing.pri)

OTHER_FILES += assets/android/src/com/emeric/sharingiscaring/QShareActivity.java \
               assets/android/src/com/emeric/sharingiscaring/QShareActivity2.java

# Project files ################################################################

SOURCES  += src/main.cpp \
            src/SettingsManager.cpp \
            src/FileSharingTest.cpp \
            src/utils/utils_app.cpp \
            src/utils/utils_screen.cpp

HEADERS  += src/SettingsManager.h \
            src/FileSharingTest.h \
            src/utils/utils_app.h \
            src/utils/utils_screen.h

RESOURCES   += qml/qml.qrc \
               i18n/i18n.qrc \
               assets/assets.qrc

OTHER_FILES += .gitignore

#TRANSLATIONS = i18n/xx_fr.ts

lupdate_only { SOURCES += qml/*.qml qml/*.js qml/components/*.qml }

# Build settings ###############################################################

DEFINES += QT_DEPRECATED_WARNINGS

CONFIG(release, debug|release) : DEFINES += QT_NO_DEBUG_OUTPUT

# Build artifacts ##############################################################

OBJECTS_DIR = build/$${QT_ARCH}/
MOC_DIR     = build/$${QT_ARCH}/
RCC_DIR     = build/$${QT_ARCH}/
UI_DIR      = build/$${QT_ARCH}/
QMLCACHE_DIR= build/$${QT_ARCH}/

DESTDIR     = bin/

################################################################################
# Application deployment and installation steps

linux:!android {
    TARGET = $$lower($${TARGET})

    SOURCES  += src/utils/utils_os_linux.cpp
    HEADERS  += src/utils/utils_os_linux.h

    # Automatic application packaging # Needs linuxdeployqt installed
    #system(linuxdeployqt $${OUT_PWD}/$${DESTDIR}/ -qmldir=qml/)

    # Application packaging # Needs linuxdeployqt installed
    #deploy.commands = $${OUT_PWD}/$${DESTDIR}/ -qmldir=qml/
    #install.depends = deploy
    #QMAKE_EXTRA_TARGETS += install deploy

    # Installation
    isEmpty(PREFIX) { PREFIX = /usr/local }
    target_app.files       += $${OUT_PWD}/$${DESTDIR}/$$lower($${TARGET})
    target_app.path         = $${PREFIX}/bin/
    target_icon.files      += $${OUT_PWD}/assets/logos/$$lower($${TARGET}).svg
    target_icon.path        = $${PREFIX}/share/pixmaps/
    target_appentry.files  += $${OUT_PWD}/assets/linux/$$lower($${TARGET}).desktop
    target_appentry.path    = $${PREFIX}/share/applications
    target_appdata.files   += $${OUT_PWD}/assets/linux/$$lower($${TARGET}).appdata.xml
    target_appdata.path     = $${PREFIX}/share/appdata
    INSTALLS += target_app target_icon target_appentry target_appdata

    # Clean appdir/ and bin/ directories
    #QMAKE_CLEAN += $${OUT_PWD}/$${DESTDIR}/$$lower($${TARGET})
    #QMAKE_CLEAN += $${OUT_PWD}/appdir/
}

android {
    # ANDROID_TARGET_ARCH: [x86_64, armeabi-v7a, arm64-v8a]
    #message("ANDROID_TARGET_ARCH: $$ANDROID_TARGET_ARCH")

    SOURCES  += src/utils/utils_os_android_qt5.cpp
    HEADERS  += src/utils/utils_os_android.h

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = sharingiscaring

    # org.qtproject.qt5.android.bindings.QtActivity
    OTHER_FILES += assets/android/src/com/emeric/sharingiscaring/QShareActivity.java

    DISTFILES += $${PWD}/assets/android/AndroidManifest.xml \
                 $${PWD}/assets/android/gradle.properties \
                 $${PWD}/assets/android/build.gradle

    ANDROID_PACKAGE_SOURCE_DIR = $${PWD}/assets/android
    #ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libtensorflowlite.so
}

ios {
    #QMAKE_IOS_DEPLOYMENT_TARGET = 11.0
    #message("QMAKE_IOS_DEPLOYMENT_TARGET: $$QMAKE_IOS_DEPLOYMENT_TARGET")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.emeric
    QMAKE_BUNDLE = sharingiscaring

    # OS icons
    QMAKE_ASSET_CATALOGS = $${PWD}/assets/ios/Images.xcassets
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    # OS infos
    QMAKE_INFO_PLIST = $${PWD}/assets/ios/Info.plist
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2 # 1: iPhone / 2: iPad / 1,2: Universal

    # iOS developer settings
    exists($${PWD}/assets/ios/ios_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        include($${PWD}/assets/ios/ios_signature.pri)
    }
}
