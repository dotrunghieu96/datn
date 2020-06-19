QT += quick core multimedia widgets

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

DEFINES += TAGLIB_STATIC

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        Media/mediadir.cpp \
        Media/mediadirmodel.cpp \
        Media/mymediaapp.cpp \
        Media/mymediaplayer.cpp \
        Media/playlistmodel.cpp \
        Media/song.cpp \
        main.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Media/mediadir.h \
    Media/mediadirmodel.h \
    Media/mymediaapp.h \
    Media/mymediaplayer.h \
    Media/playlistmodel.h \
    Media/song.h

unix|win32: LIBS += -LD:/Libraries/taglib/lib/ -ltag

INCLUDEPATH += D:/Libraries/taglib/include
DEPENDPATH += D:/Libraries/taglib/include