#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>


int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QT_QUICK_CONTROLS_CONF", QByteArray("/etc/qml4cop/qtquickcontrols2.conf"));
    qputenv("XDG_CONFIG_HOME", QByteArray("/etc"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QString extraImportPath(QStringLiteral("%1/../../../%2"));

    app.setOrganizationName(QStringLiteral("qml4cop"));
    app.setApplicationName(QStringLiteral("qml4cop"));
    app.setApplicationVersion(QStringLiteral("0.60.1"));

    QQuickView view;
    view.engine()->addImportPath(extraImportPath.arg(QGuiApplication::applicationDirPath(), QString::fromLatin1("qml")));
    QObject::connect(view.engine(), &QQmlEngine::quit, &view, &QWindow::close);

    view.setSource(QUrl(QStringLiteral("qrc:/MainPage.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);

#ifdef Q_PROCESSOR_X86_64
    view.show();
#else
    view.showFullScreen();
#endif
    return app.exec();

}
