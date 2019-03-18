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
    property string sceneTitle: ""
    property string viewMode: sceneView.currentViewpointCamera.pitch < 0.1 ? "3D" : "2D"
    property string coordinate: ""
    property string shortUrl: ""

    property bool isLocationEnabled: false
    property bool isPageLoading: false

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

    Item {
        anchors.fill: parent

        SceneView {
            id: sceneView

            anchors.fill: parent
            attributionTextVisible: false

            onViewpointChanged: {
                updateSceneView();
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40 * constants.scaleFactor

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Widgets.RoundedButton {
                        Layout.preferredWidth: 40 * constants.scaleFactor
                        Layout.fillHeight: true

                        color: locationManager.active ? colors.blue : colors.view_background

                        source: images.location_icon
                        iconColor: colors.white

                        isEnabled: locationManager.valid

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

                    Item {
                        Layout.fillWidth: true
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
                            if (typeof initialViewpointCamera !== "undefined")
                                arcGISRuntimeHelper.setCamera(sceneView, initialViewpointCamera);
                        }
                    }

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Item {
                        Layout.fillWidth: true
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
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Widgets.TouchGestureArea {
                        Layout.preferredWidth: 40 * constants.scaleFactor
                        Layout.fillHeight: true
                        color: colors.view_background
                        radius: this.width / 2

                        Label {
                            id: icon

                            anchors.centerIn: parent

                            height: 24 * constants.scaleFactor

                            text: viewMode === "2D" ? "2D" : "3D"
                            clip: true
                            elide: Text.ElideRight

                            font.family: fonts.avenirNextDemi
                            font.pixelSize: 14 * constants.scaleFactor
                            color: colors.white
                        }

                        onClicked: {
                            switchViewMode();
                        }
                    }

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Item {
                        Layout.fillWidth: true
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
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Widgets.RoundedButton {
                        Layout.preferredWidth: 40 * constants.scaleFactor
                        Layout.fillHeight: true

                        color: colors.view_background

                        source: images.compass_icon
                        iconRotation: sceneView.currentViewpointCamera.heading
                        iconSize: 32 * constants.scaleFactor

                        onClicked: {
                            rotateToNorth();
                        }
                    }

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 40 * constants.scaleFactor

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24 * constants.scaleFactor

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }

                            Rectangle {
                                Layout.preferredWidth: coordinateLabel.width
                                Layout.fillHeight: true
                                color: colors.black

                                Label {
                                    id: coordinateLabel

                                    width: this.implicitWidth
                                    height: parent.height

                                    text: coordinate
                                    clip: true
                                    elide: Text.ElideRight

                                    font.family: fonts.avenirNextRegular
                                    font.pixelSize: 14 * constants.scaleFactor
                                    color: colors.white

                                    horizontalAlignment: Label.AlignHCenter
                                    verticalAlignment: Label.AlignVCenter

                                    leftPadding: 16 * constants.scaleFactor
                                    rightPadding: 16 * constants.scaleFactor
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        width: parent.width
        height: 56 * constants.scaleFactor

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            color: colors.black
            opacity: 0.38
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.preferredWidth: 8 * constants.scaleFactor
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: 40 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.RoundedButton {
                    width: 40 * constants.scaleFactor
                    height: this.width
                    anchors.centerIn: parent

                    color: colors.transparent

                    source: images.close_icon
                    iconColor: colors.white

                    onClicked: {
                        closed();
                    }
                }
            }

            Item {
                Layout.preferredWidth: 8 * constants.scaleFactor
                Layout.fillHeight: true
            }

            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: sceneTitle
                clip: true
                elide: Text.ElideRight

                font.family: fonts.avenirNextDemi
                font.pixelSize: 20 * constants.scaleFactor
                color: colors.white

                horizontalAlignment: Label.AlignLeft
                verticalAlignment: Label.AlignVCenter
            }

            Item {
                Layout.preferredWidth: 8 * constants.scaleFactor
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: 40 * constants.scaleFactor
                Layout.fillHeight: true
                visible: false

                Widgets.RoundedButton {
                    width: 40 * constants.scaleFactor
                    height: this.width
                    anchors.centerIn: parent

                    color: colors.transparent

                    source: images.book_marks_icon
                    iconColor: colors.white

                    onClicked: {
                        bookMarkSlideMenu.open();
                    }
                }
            }

            Item {
                Layout.preferredWidth: 8 * constants.scaleFactor
                Layout.fillHeight: true
                visible: false
            }

            Item {
                Layout.preferredWidth: 40 * constants.scaleFactor
                Layout.fillHeight: true

                Widgets.RoundedButton {
                    width: 40 * constants.scaleFactor
                    height: this.width
                    anchors.centerIn: parent

                    color: colors.transparent

                    source: images.more_option_icon
                    iconColor: colors.white

                    isEnabled: shortUrl > ""

                    onClicked: {
                        openShareSheet();
                    }
                }
            }

            Item {
                Layout.preferredWidth: 8 * constants.scaleFactor
                Layout.fillHeight: true
            }
        }

        Widgets.LinearGadientLoadingBar {
            width: parent.width
            height: 4 * constants.scaleFactor

            anchors.left: parent.left
            anchors.top: parent.top

            visible: sceneView.drawStatus === Enums.DrawStatusInProgress

            Behavior on visible {
                NumberAnimation { duration: constants.normalDuration }
            }
        }
    }

    BookMarkSlideMenu{
        id: bookMarkSlideMenu

        width: 0.78 * parent.width
        height: parent.height

        onClicked: {

        }
    }

    Component.onCompleted: {
        initial();
    }

    function initial() {
        isPageLoading = true;

        createScene();
        getShortenedUrl(sceneUrl, function() {
            isPageLoading = false;
        });
    }

    function createScene() {
        var _scene = ArcGISRuntimeEnvironment.createObject(
                    "Scene", {
                        initUrl: sceneUrl
                    });

        _scene.onLoadStatusChanged.connect(function() {
            if (_scene.loadStatus === 0)
                initialViewpointCamera = sceneView.scene.initialViewpoint.camera;
        });

        sceneView.scene = _scene;
    }

    function openShareSheet() {
        AppFramework.clipboard.share(AppFramework.urlInfo(shortUrl).url);
    }

    function getShortenedUrl(url, process) {
        var promise = new Promise(function(resolve, reject) {
            networkManager.requestShortenedUrl(url, function(response) {
                try {
                    if (!infoPage)
                        return;

                    var json = JSON.parse(response.responseText);

                    if (json.hasOwnProperty("data"))
                        shortUrl = json.data.url;
                    else
                        shortUrl = url;

                    resolve();
                } catch (e) {
                    reject("Error in InfoPage requestShortenedUrl(): " + e);
                }
            })
        })

        promise.then(function() {
            process();
        }).catch(function(e) {
            console.log(e);
        })
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

        arcGISRuntimeHelper.setCamera(sceneView, _camera);
    }

    function rotateToNorth() {
        var _camera = sceneView.currentViewpointCamera;
        var _point = sceneView.currentViewpointCenter.center;

        var _deltaRotation = {
            heading: _camera.heading,
            pitch: 0,
            roll: 0
        }

        arcGISRuntimeHelper.cameraRotateAround(sceneView, _point, _deltaRotation);
    }

    function switchViewMode() {
        var _camera = sceneView.currentViewpointCamera;
        var _point = sceneView.currentViewpointCenter.center;
        var _deltaRotation = {};

        if (viewMode === "2D") {
            _deltaRotation = {
                heading: 0,
                pitch: -_camera.pitch,
                roll: 0
            }
        } else {
            _deltaRotation = {
                heading: 0,
                pitch: 45,
                roll: 0
            }
        }

        arcGISRuntimeHelper.cameraRotateAround(sceneView, _point, _deltaRotation);
    }

    function updateSceneView() {
        if (!sceneView.currentViewpointCenter.center)
            return;

        coordinate = arcGISRuntimeHelper.changePointToLatitudeLongitude(sceneView.currentViewpointCenter.center, Enums.LatitudeLongitudeFormatDegreesMinutesSeconds, 3);
    }
}
