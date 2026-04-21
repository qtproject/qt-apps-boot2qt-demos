cmake_minimum_required(VERSION 3.16)
project(qtremotedesktop LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml)

qt_add_executable(qtremotedesktop
    main.cpp
)

set_target_properties(qtremotedesktop PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(qtremotedesktop PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Qml
)

qt6_add_resources(qtremotedesktop "qtremotedesktop"
    PREFIX
        "/"
    FILES
        "main.qml"
)

install(TARGETS qtremotedesktop
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
