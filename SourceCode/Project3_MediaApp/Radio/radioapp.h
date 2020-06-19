#ifndef RADIOAPP_H
#define RADIOAPP_H

#include <QObject>

class RadioApp : public QObject
{
    Q_OBJECT
public:
    explicit RadioApp(QObject *parent = nullptr);

signals:

public slots:
};

#endif // RADIOAPP_H
