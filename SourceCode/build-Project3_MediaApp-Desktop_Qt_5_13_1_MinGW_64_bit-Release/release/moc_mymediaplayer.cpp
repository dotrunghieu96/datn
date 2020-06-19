/****************************************************************************
** Meta object code from reading C++ file 'mymediaplayer.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../Project3_MediaApp/Media/mymediaplayer.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mymediaplayer.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_MyMediaPlayer_t {
    QByteArrayData data[31];
    char stringdata0[415];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_MyMediaPlayer_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_MyMediaPlayer_t qt_meta_stringdata_MyMediaPlayer = {
    {
QT_MOC_LITERAL(0, 0, 13), // "MyMediaPlayer"
QT_MOC_LITERAL(1, 14, 22), // "nowPlayingIndexChanged"
QT_MOC_LITERAL(2, 37, 0), // ""
QT_MOC_LITERAL(3, 38, 15), // "nowPlayingIndex"
QT_MOC_LITERAL(4, 54, 19), // "playbackModeChanged"
QT_MOC_LITERAL(5, 74, 11), // "currentMode"
QT_MOC_LITERAL(6, 86, 14), // "shuffleChanged"
QT_MOC_LITERAL(7, 101, 9), // "isShuffle"
QT_MOC_LITERAL(8, 111, 15), // "durationChanged"
QT_MOC_LITERAL(9, 127, 8), // "duration"
QT_MOC_LITERAL(10, 136, 15), // "positionChanged"
QT_MOC_LITERAL(11, 152, 8), // "position"
QT_MOC_LITERAL(12, 161, 21), // "mediaAvailableChanged"
QT_MOC_LITERAL(13, 183, 14), // "mediaAvailable"
QT_MOC_LITERAL(14, 198, 16), // "isPlayingChanged"
QT_MOC_LITERAL(15, 215, 9), // "isPlaying"
QT_MOC_LITERAL(16, 225, 16), // "triggerAnimation"
QT_MOC_LITERAL(17, 242, 11), // "isIncreased"
QT_MOC_LITERAL(18, 254, 8), // "setMedia"
QT_MOC_LITERAL(19, 263, 5), // "index"
QT_MOC_LITERAL(20, 269, 20), // "setPositionByPercent"
QT_MOC_LITERAL(21, 290, 7), // "percent"
QT_MOC_LITERAL(22, 298, 13), // "toggleShuffle"
QT_MOC_LITERAL(23, 312, 18), // "switchPlaybackMode"
QT_MOC_LITERAL(24, 331, 10), // "togglePlay"
QT_MOC_LITERAL(25, 342, 4), // "next"
QT_MOC_LITERAL(26, 347, 8), // "previous"
QT_MOC_LITERAL(27, 356, 13), // "getTimeString"
QT_MOC_LITERAL(28, 370, 11), // "miliseconds"
QT_MOC_LITERAL(29, 382, 19), // "mediaChangedHandler"
QT_MOC_LITERAL(30, 402, 12) // "playbackMode"

    },
    "MyMediaPlayer\0nowPlayingIndexChanged\0"
    "\0nowPlayingIndex\0playbackModeChanged\0"
    "currentMode\0shuffleChanged\0isShuffle\0"
    "durationChanged\0duration\0positionChanged\0"
    "position\0mediaAvailableChanged\0"
    "mediaAvailable\0isPlayingChanged\0"
    "isPlaying\0triggerAnimation\0isIncreased\0"
    "setMedia\0index\0setPositionByPercent\0"
    "percent\0toggleShuffle\0switchPlaybackMode\0"
    "togglePlay\0next\0previous\0getTimeString\0"
    "miliseconds\0mediaChangedHandler\0"
    "playbackMode"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_MyMediaPlayer[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      17,   14, // methods
       7,  138, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       8,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   99,    2, 0x06 /* Public */,
       4,    1,  102,    2, 0x06 /* Public */,
       6,    1,  105,    2, 0x06 /* Public */,
       8,    1,  108,    2, 0x06 /* Public */,
      10,    1,  111,    2, 0x06 /* Public */,
      12,    1,  114,    2, 0x06 /* Public */,
      14,    1,  117,    2, 0x06 /* Public */,
      16,    1,  120,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      18,    1,  123,    2, 0x0a /* Public */,
      20,    1,  126,    2, 0x0a /* Public */,
      22,    0,  129,    2, 0x0a /* Public */,
      23,    0,  130,    2, 0x0a /* Public */,
      24,    0,  131,    2, 0x0a /* Public */,
      25,    0,  132,    2, 0x0a /* Public */,
      26,    0,  133,    2, 0x0a /* Public */,
      27,    1,  134,    2, 0x0a /* Public */,
      29,    0,  137,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    5,
    QMetaType::Void, QMetaType::Bool,    7,
    QMetaType::Void, QMetaType::LongLong,    9,
    QMetaType::Void, QMetaType::LongLong,   11,
    QMetaType::Void, QMetaType::Bool,   13,
    QMetaType::Void, QMetaType::Bool,   15,
    QMetaType::Void, QMetaType::Bool,   17,

 // slots: parameters
    QMetaType::Void, QMetaType::Int,   19,
    QMetaType::Void, QMetaType::Int,   21,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::QString, QMetaType::LongLong,   28,
    QMetaType::Void,

 // properties: name, type, flags
       9, QMetaType::LongLong, 0x00495001,
      11, QMetaType::LongLong, 0x00495001,
      13, QMetaType::Bool, 0x00495001,
      15, QMetaType::Bool, 0x00495001,
       3, QMetaType::Int, 0x00495001,
       7, QMetaType::Bool, 0x00495001,
      30, QMetaType::Int, 0x00495001,

 // properties: notify_signal_id
       3,
       4,
       5,
       6,
       0,
       2,
       1,

       0        // eod
};

void MyMediaPlayer::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<MyMediaPlayer *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->nowPlayingIndexChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: _t->playbackModeChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 2: _t->shuffleChanged((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 3: _t->durationChanged((*reinterpret_cast< qint64(*)>(_a[1]))); break;
        case 4: _t->positionChanged((*reinterpret_cast< qint64(*)>(_a[1]))); break;
        case 5: _t->mediaAvailableChanged((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 6: _t->isPlayingChanged((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 7: _t->triggerAnimation((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 8: _t->setMedia((*reinterpret_cast< const int(*)>(_a[1]))); break;
        case 9: _t->setPositionByPercent((*reinterpret_cast< const int(*)>(_a[1]))); break;
        case 10: _t->toggleShuffle(); break;
        case 11: _t->switchPlaybackMode(); break;
        case 12: _t->togglePlay(); break;
        case 13: _t->next(); break;
        case 14: _t->previous(); break;
        case 15: { QString _r = _t->getTimeString((*reinterpret_cast< qint64(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 16: _t->mediaChangedHandler(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (MyMediaPlayer::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::nowPlayingIndexChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::playbackModeChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::shuffleChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(qint64 );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::durationChanged)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(qint64 );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::positionChanged)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::mediaAvailableChanged)) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::isPlayingChanged)) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (MyMediaPlayer::*)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MyMediaPlayer::triggerAnimation)) {
                *result = 7;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<MyMediaPlayer *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< qint64*>(_v) = _t->duration(); break;
        case 1: *reinterpret_cast< qint64*>(_v) = _t->position(); break;
        case 2: *reinterpret_cast< bool*>(_v) = _t->mediaAvailable(); break;
        case 3: *reinterpret_cast< bool*>(_v) = _t->isPlaying(); break;
        case 4: *reinterpret_cast< int*>(_v) = _t->nowPlayingIndex(); break;
        case 5: *reinterpret_cast< bool*>(_v) = _t->isShuffle(); break;
        case 6: *reinterpret_cast< int*>(_v) = _t->playbackMode(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject MyMediaPlayer::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_MyMediaPlayer.data,
    qt_meta_data_MyMediaPlayer,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *MyMediaPlayer::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MyMediaPlayer::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_MyMediaPlayer.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int MyMediaPlayer::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 17)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 17;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 7;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void MyMediaPlayer::nowPlayingIndexChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void MyMediaPlayer::playbackModeChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void MyMediaPlayer::shuffleChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void MyMediaPlayer::durationChanged(qint64 _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void MyMediaPlayer::positionChanged(qint64 _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}

// SIGNAL 5
void MyMediaPlayer::mediaAvailableChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void MyMediaPlayer::isPlayingChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}

// SIGNAL 7
void MyMediaPlayer::triggerAnimation(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 7, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
