/*!
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \author    Emeric Grange <emeric.grange@gmail.com>
 * \date      2019
 */

#include "utils/utils_app.h"
#include "utils/utils_screen.h"
#include "utils/utils_os_android.h"
#include "SettingsManager.h"
#include "FileSharingTest.h"

#include <MobileUI.h>
#include <SharingApplication.h>

#include <QApplication>
#include <QTranslator>
#include <QLibraryInfo>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#if defined(Q_OS_ANDROID)
#include <QtAndroid>
#endif

/* ************************************************************************** */

int main(int argc, char *argv[])
{
    // GUI application /////////////////////////////////////////////////////////

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

    //QApplication app(argc, argv);
    SharingApplication app(argc, argv);

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    QIcon appIcon(":/assets/logos/logo.svg");
    app.setWindowIcon(appIcon);
#endif

    // Application name
    app.setApplicationName("SharingIsCaring");
    app.setApplicationDisplayName("Sharing is Caring");
    app.setOrganizationName("emeric");
    app.setOrganizationDomain("emeric");
/*
    // i18n
    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator appTranslator;
    appTranslator.load(":/i18n/bmu.qm");
    app.installTranslator(&appTranslator);
*/
    // Init components
    SettingsManager *sm = SettingsManager::getInstance();
    if (!sm) return EXIT_FAILURE;

    UtilsApp *utilsApp = UtilsApp::getInstance();
    if (!utilsApp) return EXIT_FAILURE;

    UtilsScreen *utilsScreen = UtilsScreen::getInstance();
    if (!utilsScreen) return EXIT_FAILURE;

    //UtilsLanguage *utilsLanguage = UtilsLanguage::getInstance();
    //if (!utilsLanguage) return EXIT_FAILURE;

    FileSharingTest *utilsFiles = FileSharingTest::getInstance();
    if (!utilsFiles) return EXIT_FAILURE;

    // Mobile UI
    qmlRegisterType<MobileUI>("MobileUI", 1, 0, "MobileUI");

    // ThemeEngine
    qmlRegisterSingletonType(QUrl("qrc:/qml/ThemeEngine.qml"), "ThemeEngine", 1, 0, "Theme");

    // Then we start the UI
    QQmlApplicationEngine engine;
    QQmlContext *engine_context = engine.rootContext();
    engine_context->setContextProperty("settingsManager", sm);
    engine_context->setContextProperty("utilsApp", utilsApp);
    engine_context->setContextProperty("utilsScreen", utilsScreen);
    engine_context->setContextProperty("utilsFiles", utilsFiles);
    //engine_context->setContextProperty("utilsLanguage", utilsLanguage);

    app.registerQML(engine_context);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Application.qml")));
    if (engine.rootObjects().isEmpty()) return EXIT_FAILURE;

    // For i18n retranslate
    //utilsLanguage->setQmlEngine(&engine);

    // QQuickWindow must be valid at this point
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().value(0));
    engine_context->setContextProperty("quickWindow", window);

#if defined(Q_OS_ANDROID)
    QtAndroid::hideSplashScreen(333);
#endif

    return app.exec();
}

/* ************************************************************************** */
