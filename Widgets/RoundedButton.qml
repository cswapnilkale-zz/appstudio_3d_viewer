import QtQuick 2.9
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

TouchGestureArea {
    radius: this.width / 2

    property alias source: icon.source
    property alias iconColor: icon.color

    IconImage {
        id: icon

        width: 24 * constants.scaleFactor
        height: this.width
        anchors.centerIn: parent
    }
}
