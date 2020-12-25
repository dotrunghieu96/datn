QT += quick core multimedia

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
        Media/mediaplaybackinfo.cpp \
        Media/myaudioplayer.cpp \
        Media/mymediaapp.cpp \
        Media/playlistmodel.cpp \
        Media/song.cpp \
        Media/video.cpp \
        Media/videoplaylistmodel.cpp \
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
    Media/mediaplaybackinfo.h \
    Media/myaudioplayer.h \
    Media/mymediaapp.h \
    Media/playlistmodel.h \
    Media/song.h \
    Media/video.h \
    Media/videoplaylistmodel.h

unix|win32: LIBS += -L$$PWD/Libs/taglib/lib/ -ltag

INCLUDEPATH += $$PWD/Libs/taglib/include
DEPENDPATH += $$PWD/Libs/taglib/include

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/Libs/taglib/lib/tag.lib
else:unix|win32-g++: PRE_TARGETDEPS += $$PWD/Libs/taglib/lib/libtag.a
