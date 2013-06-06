import QtDroid.Utils 1.0
import QtQuick 2.0

QtObject {

    function getIPAddress()
    {
        return DroidUtils.getIPAddress()
    }

    function getHostname()
    {
        return DroidUtils.getHostname()
    }

    function setHostname(value)
    {
        return DroidUtils.setHostname(value)
    }

}
