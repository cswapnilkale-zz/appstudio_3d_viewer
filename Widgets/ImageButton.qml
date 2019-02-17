import QtQuick 2.9
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import QtGraphicalEffects 1.0

ToolButton {
    anchors.centerIn: parent

    property real imageWidth: 24 * constants.scaleFactor

    property alias imageIcon: image.source
    property alias overlayColor: colorOverlay.color
    property alias imageRotation: image.rotation

    indicator: Image {
        id: image

        width: imageWidth
        height: this.width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    ColorOverlay {
        id: colorOverlay

        anchors.fill: image
        source: image
        rotation: image.rotation
    }
}
