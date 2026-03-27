pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.11
import DVAGLogger 1.0


QtObject {
    id: qmlSettingsManager

    function foo_function(inputString) {
        DVAGLogger.log("***** Meine Foo-Funktion schreibt ... " + inputString + " *************")
    }
}
