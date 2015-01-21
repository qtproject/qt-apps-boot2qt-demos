TEMPLATE = subdirs

libfreenect.file = libfreenect.pro

quickfreenect.file = quickfreenect/quickfreenect.pro
quickfreenect.depends = libfreenect

SUBDIRS += libfreenect \
           quickfreenect
