# Qt 3D Studio Home Automation Demo

This demo application is created with Qt 3D Studio and Qt Quick.
It uses a Qt 3D presentation (.uip file) to show what home automation application could look like.
The demo has controls to change lighting and temperature (represented as color) of the rooms.

![Home Automation Demo](/HomeAutomation/images/home-automation-demo.png)

The application is designed to be used with Pixel C, but it also has basic scaling in place.
By default the screen size is used as the main application window size. Uncommenting FIXEDWINDOW
definition from main.cpp will force the main application window to be of size 1280x900.

Config variable KNX_BOARD can be used to compile the application so that it controls the
KNX board.

