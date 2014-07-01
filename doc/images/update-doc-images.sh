rm b2qt-demo-*
find ../../basicsuite/ -name "preview_l.jpg" -execdir sh -c 'ln -s ../../basicsuite/${PWD##*/}/preview_l.jpg ../../doc/images/b2qt-demo-${PWD##*/}.jpg' \;
