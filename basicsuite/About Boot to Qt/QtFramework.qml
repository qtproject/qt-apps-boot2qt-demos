import QtQuick 2.0

Column {
    id: root

    width: parent.width

    spacing: engine.smallFontSize()

    Title {
        text: "Qt Framework"
    }

    ContentText {
        id: brief
        width: parent.width
        text: '<p align="justify">Qt is a full development framework with tools designed to streamline
               the creation of applications and user interfaces for desktop, embedded
               and mobile platforms.
               <ul>
                <li><b>Qt Framework</b> - intuitive APIs for C++ and CSS/JavaScript-like
                    programming with Qt Quick for rapid UI creation<\li>
                <li><b>Qt Creator IDE</b> - powerful cross-platform integrated
                    development environment, including UI designer tools and on-device debugging</li>
                <li><b>Tools and toolchains</b> - internationalization support, embedded toolchains
                    and more.</li>
               </ul>
               <p align="justify">With Qt, you can reuse code efficiently to target multiple platforms
               with one code base. The modular C++ class library and developer tools
               easily enables developers to create applications for one platform and
               easily build and run to deploy on another platform.'
    }


}
