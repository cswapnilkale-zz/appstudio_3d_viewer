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

    signal closed()

    header: ToolBar {
        height: 56 * constants.scaleFactor
        Material.primary: colors.view_background
        Material.elevation: 0

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.preferredWidth: 56 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.ImageButton {
                    imageIcon: images.close_icon

                    onClicked: {
                        closed();
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: 56 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.ImageButton {
                    imageIcon: images.more_option_icon

                    onClicked: {

                    }
                }
            }
        }
    }

    Item {
        anchors.fill: parent

        SceneView {
            id: sceneView

            anchors.fill: parent
            attributionTextVisible: false

            Scene {
                initUrl: sceneUrl
            }

            Component.onCompleted: {
                setViewpointCameraAndWait(camera);
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40 * constants.scaleFactor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40 * constants.scaleFactor

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Widgets.RoundedButton {
                        Layout.preferredWidth: 40 * constants.scaleFactor
                        Layout.fillHeight: true

                        color: colors.view_background

                        source: images.home_icon
                        iconColor: colors.white

                        onClicked: {
                            sceneNavigateBackHome();
                        }
                    }

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        Widgets.ProgressIndicator {
            anchors.fill: parent
            isMasked: false
            visible: (sceneView.drawStatus === Enums.DrawStatusInProgress)
        }
    }

    Camera {
        id: camera

        heading: 10.0
        pitch: 80.0
        roll: 0.0
    }

    function sceneNavigateBackHome() {
        sceneView.setViewpointCamera(camera);
    }
}
