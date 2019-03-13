import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import "Assets" as Assets
import "Controls" as Controls

App {
    id: app

    width: 421
    height: 725

    Material.background: colors.view_background

    LayoutMirroring.enabled: appManager.isRTL
    LayoutMirroring.childrenInherit: appManager.isRTL

    // Reference
    property alias colors: colors
    property alias constants: constants
    property alias strings: strings
    property alias fonts: fonts
    property alias images: images
    property alias components: components
    property alias appManager: appManager
    property alias locationManager: locationManager

    // Assets
    Assets.Colors { id: colors }
    Assets.Strings { id: strings }
    Assets.Fonts { id: fonts }
    Assets.Images { id: images }
    Assets.Components { id: components }
    Assets.Constants { id: constants }

    // Controls
    Controls.AppManager {
        id: appManager
    }

    // Network manager
    Controls.NetworkManager {
        id: networkManager

        rootUrl: constants.orgUrl + "/sharing/rest"
    }

    Controls.LocationManager {
        id: locationManager
    }

    StackView {
        id: stackView

        anchors.fill: parent
        initialItem: components.landingPageComponent
    }

    Component.onCompleted: {
        appManager.initialize();
    }
}

