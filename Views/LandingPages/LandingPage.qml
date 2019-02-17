import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Authentication 1.0

import "../../Widgets" as Widgets

Page {
    id: landingPage

    Material.background: colors.view_background

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 56 * constants.scaleFactor

            Widgets.TextButton {
                width: content.width
                height: parent.height
                radius: this.height / 2
                color: colors.theme

                anchors.centerIn: parent

                fontFamily: fonts.system

                buttonText: strings.start

                onClicked: {
                    var homePage = components.homePageComponent.createObject(null);

                    homePage.onBack.connect(function() {
                        stackView.pop();
                    });

                    stackView.push(homePage);
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 68 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: appManager.isiPhoneX ? 28 * constants.scaleFactor : 0
        }
    }
}
