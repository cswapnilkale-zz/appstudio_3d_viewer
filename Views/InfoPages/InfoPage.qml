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

    property bool isLocationEnabled: false

    property var initialViewpointCamera

    signal closed()

    Connections {
        target: locationManager

        onPositionChanged: {
            var _coordinateString = "%1 %2".arg(locationManager.coordinate.latitude).arg(locationManager.coordinate.longitude);

            var _point = CoordinateFormatter.fromLatitudeLongitude(_coordinateString, SpatialReference.createWgs84());

            var _location = {
                x: _point.x,
                y: _point.y,
                z: locationManager.coordinate.altitude
            }

            var _rotation = {
                heading: sceneView.currentViewpointCamera.heading,
                pitch: 0,
                roll: sceneView.currentViewpointCamera.roll
            }

            manipulateCamera(_rotation, _location);
        }
    }

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

                Widgets.RoundedButton {
                    width: 40 * constants.scaleFactor
                    height: this.width
                    anchors.centerIn: parent

                    color: colors.view_background

                    source: images.close_icon
                    iconColor: colors.white

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
                Layout.preferredWidth: 40 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.RoundedButton {
                    width: 40 * constants.scaleFactor
                    height: this.width
                    anchors.centerIn: parent

                    color: colors.view_background

                    source: images.book_marks_icon
                    iconColor: colors.white

                    onClicked: {
                        bookMarkSlideMenu.open();
                    }
                }
            }

            Item {
                Layout.preferredWidth: 56 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.RoundedButton {
                    width: 40 * constants.scaleFactor
                    height: this.width
                    anchors.centerIn: parent

                    color: colors.view_background

                    source: images.more_option_icon
                    iconColor: colors.white

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

                onLoadStatusChanged: {
                    if (loadStatus === 0)
                        initialViewpointCamera = sceneView.scene.initialViewpoint.camera;
                }
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

                        color: colors.white

                        source: images.home_icon
                        iconColor: colors.view_background

                        onClicked: {
                            if (typeof initialViewpointCamera !== "undefined")
                                navigateCamera(initialViewpointCamera);
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

                        color: locationManager.active ? colors.blue : colors.white

                        source: images.location_icon
                        iconColor: locationManager.active ? colors.white : colors.view_background

                        onClicked: {
                            isLocationEnabled = !isLocationEnabled;

                            if (isLocationEnabled)
                                locationManager.start();
                            else
                                locationManager.stop();
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

                        color: isHeadingNorth ? colors.blue : colors.white

                        source: images.compass_icon
                        iconColor: isHeadingNorth ? colors.white : colors.view_background
                        iconRotation: sceneView.currentViewpointCamera.heading

                        property bool isHeadingNorth: 360 % sceneView.currentViewpointCamera.heading < 0.1

                        onClicked: {
                            rotateToNorth();
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
        var _openUrlMenuItem = components.menuItemComponent.createObject(null, { text: strings.open_url });

        _openUrlMenuItem.onTriggered.connect(function() {
            Qt.openUrlExternally(sceneUrl);
        });

        optionMenu.addItem(_openUrlMenuItem);

        var _bookmarks = sceneView.scene.bookmarks;

        for (var i = 0; i < _bookmarks.count; i++) {
            var _bookmark = _bookmarks.get(i);

            var _obj = {
                bookmarkName: _bookmark.name,
                bookmarkViewpoint: _bookmark.viewpoint
            }

            bookMarkSlideMenu.listView.model.append(_obj);
        }
    }

    function navigateCamera(camera) {
        sceneView.setViewpointCamera(camera);
    }

    function manipulateCamera(rotation, location) {
        var _location = ArcGISRuntimeEnvironment.createObject(
                    "Point", {
                        x: location.x,
                        y: location.y,
                        z: location.z,
                        SpatialReference: SpatialReference.createWgs84()
                    })

        var _camera = ArcGISRuntimeEnvironment.createObject(
                    "Camera", {
                        heading: rotation.heading,
                        pitch: rotation.pitch,
                        roll: rotation.roll,
                        location: _location
                    });

        navigateCamera(_camera);
    }

    function rotateToNorth() {
        var _deltaHeading = sceneView.currentViewpointCamera.heading;

        _deltaHeading = _deltaHeading - 360;

        var camera = sceneView.currentViewpointCamera.rotateAround(
                    sceneView.currentViewpointCenter.center,
                    _deltaHeading,
                    0,
                    0);

        navigateCamera(camera);
    }
}
