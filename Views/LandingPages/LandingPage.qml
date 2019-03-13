import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Authentication 1.0

import Esri.ArcGISRuntime 100.5

import "../../Widgets" as Widgets

Page {
    id: landingPage

    Material.background: colors.black

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 108 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: appTitle.height

            Label {
                id: appTitle

                width: parent.width
                height: this.implicitHeight

                text: strings.app_title
                color: colors.white
                font.family: fonts.avenirNextBold
                font.pixelSize: 38 * constants.scaleFactor
                elide: Text.ElideRight
                clip: true

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                leftPadding: 16 * constants.scaleFactor
                rightPadding: 16 * constants.scaleFactor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                height: parent.height / 5 * 4

                fillMode: Image.PreserveAspectFit

                anchors.centerIn: parent

                source: images.earth_icon
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 56 * constants.scaleFactor

            Widgets.TextButton {
                width: content.width
                height: parent.height

                radius: 4 * constants.scaleFactor
                color: colors.blue

                anchors.centerIn: parent

                fontFamily: fonts.system

                textSize: 14 * constants.scaleFactor

                buttonText: strings.start_button

                onClicked: {
                    var _homePage = components.homePageComponent.createObject(null);

                    _homePage.onBack.connect(function() {
                        stackView.pop();
                    });

                    stackView.push(_homePage);
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 62 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: appManager.isiPhoneX ? 28 * constants.scaleFactor : 0
        }
    }
}
