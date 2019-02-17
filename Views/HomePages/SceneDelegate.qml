import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import "../../Widgets" as Widgets

Widgets.TouchGestureArea {
    id: root

    width: Math.min(parent.width, appManager.maximumScreenWidth)
    height: 72 * constants.scaleFactor
    anchors.horizontalCenter: parent.horizontalCenter
    color: colors.white

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.preferredWidth: 16 * constants.scaleFactor
            Layout.fillHeight: true
        }

        Item {
            Layout.preferredWidth: 40 * constants.scaleFactor
            Layout.fillHeight: true

            Widgets.IconImage {
                width: 40 * constants.scaleFactor
                height: this.width
                source: itemThumbnail
                anchors.centerIn: parent
            }
        }

        Item {
            Layout.preferredWidth: 16 * constants.scaleFactor
            Layout.fillHeight: true
        }

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: itemTitle
            elide: Label.ElideRight
            clip: true

            font.pixelSize: 16 * constants.scaleFactor
            color: colors.black

            horizontalAlignment: Label.AlignLeft
            verticalAlignment: Label.AlignVCenter
        }

        Item {
            Layout.preferredWidth: 16 * constants.scaleFactor
            Layout.fillHeight: true
        }
    }
}
