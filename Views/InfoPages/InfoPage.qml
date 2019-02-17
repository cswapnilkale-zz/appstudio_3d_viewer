import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import Esri.ArcGISRuntime 100.5

import "../../Widgets" as Widgets

Page {
    id: infoPage

    Material.background: colors.view_background

    property string sceneUrl: ""

    signal back()

    header: ToolBar {
        height: 56 * constants.scaleFactor
        Material.primary: colors.theme
        Material.elevation: 0

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.preferredWidth: 56 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.ImageButton {
                    imageIcon: images.navigate_back_icon

                    onClicked: {
                        back();
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Item {
        anchors.fill: parent

        SceneView {
            id:sceneView

            anchors.fill: parent

            Scene {
                initUrl: sceneUrl
            }
        }
    }
}
