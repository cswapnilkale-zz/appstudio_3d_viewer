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
                        optionMenu.open();
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
                            adjustCameraAngle();
                            //                            if (sceneView.scene.initialViewpoint.camera)
                            //                                navigateCamera(sceneView.scene.initialViewpoint.camera);
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
                Layout.preferredHeight: 16 * constants.scaleFactor
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

                        source: images.book_marks_icon
                        iconColor: colors.white

                        onClicked: {
                            bookMarkSlideMenu.open();
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

    BookMarkSlideMenu{
        id: bookMarkSlideMenu

        width: 0.78 * parent.width
        height: parent.height

        onClicked: {
            navigateCamera(bookmarkViewpoint.camera);
        }
    }

    MouseArea {
        anchors.fill: parent
        preventStealing: true
        visible: optionMenu.visible
    }

    Widgets.OptionMenu {
        id: optionMenu

        x: appManager.isRTL ? 8 * constants.scaleFactor : parent.width - this.width - 8 * constants.scaleFactor
        y: - 40 * constants.scaleFactor
    }

    Component.onCompleted: {
        populateUI();
    }

    function populateUI() {
        var openUrlItem = components.menuItemComponent.createObject(null, { text: strings.open_url });

        openUrlItem.onTriggered.connect(function() {
            Qt.openUrlExternally(sceneUrl);
        });

        optionMenu.addItem(openUrlItem);

        var bookmarks = sceneView.scene.bookmarks;

        for (var i = 0; i < bookmarks.count; i++) {
            var bookmark = bookmarks.get(i);

            var obj = {
                bookmarkName: bookmark.name,
                bookmarkViewpoint: bookmark.viewpoint
            }

            bookMarkSlideMenu.listView.model.append(obj);
        }
    }

    function navigateCamera(camera) {
        sceneView.setViewpointCamera(camera);
    }

    function adjustCameraAngle() {
        var referenceCamera = sceneView.currentViewpointCamera;

        var camera = components.cameraComponent.createObject(parent);
        camera.heading = referenceCamera.heading;
        camera.pitch = referenceCamera.pitch + 20;
        camera.roll = referenceCamera.roll;
        camera.location = referenceCamera.location;

        navigateCamera(camera);
    }
}
