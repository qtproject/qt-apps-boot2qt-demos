import QtQuick.Controls 1.0
import QtDroid.Utils 1.0

Action
{
    text: "Power Off!"
    onTriggered: DroidUtils.powerOffSystem()();
}
