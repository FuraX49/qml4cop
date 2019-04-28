/*
#include <QGuiApplication>
#include <QtQml/QQmlEngine>
#include <QtQuick/QQuickView>
#include <QQmlContext>
*/
#include <QtWidgets/QApplication>
#include <QtCore/QDir>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlEngine>


int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QT_QUICK_CONTROLS_CONF", QByteArray("/etc/qml4cop/qtquickcontrols2.conf"));
    qputenv("XDG_CONFIG_HOME", QByteArray("/etc"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setOrganizationName(QStringLiteral("qml4cop"));
    app.setApplicationName(QStringLiteral("qml4cop"));
    app.setApplicationVersion(QStringLiteral("0.2.0"));

    QQmlApplicationEngine engine;
      engine.load(QUrl(QStringLiteral("qrc:/MainPage.qml")));
      if (engine.rootObjects().isEmpty())
          return -1;

/*
    QQuickView view;

    view.setSource(QUrl(QStringLiteral("qrc:/MainPage.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QObject::connect(view.engine(), SIGNAL(quit()), qApp, SLOT(quit()));

#ifdef Q_PROCESSOR_X86_64
    view.show();
#else
    view.showFullScreen();
#endif
*/
    return app.exec();

}
