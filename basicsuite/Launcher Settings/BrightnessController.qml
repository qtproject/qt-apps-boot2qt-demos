import QtDroid.Utils 1.0
import QtQuick 2.0

QtObject {
    function setBrightness(value)
    {
        DroidUtils.setDisplayBrightness(value)
    }
}
