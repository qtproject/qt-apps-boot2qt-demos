QT += quick

DESTPATH = /data/user/$$TARGET
target.path = $$DESTPATH

excludeFile.files = exclude.txt
excludeFile.path = $$DESTPATH
INSTALLS += excludeFile

SOURCES += $$PWD/main.cpp \
           $$PWD/engine.cpp

HEADERS += $$PWD/engine.h
