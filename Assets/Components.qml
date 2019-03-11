import QtQuick 2.9

import Esri.ArcGISRuntime 100.5

import "../Views/HomePages" as HomePages
import "../Views/LandingPages" as LandingPages
import "../Views/InfoPages" as InfoPages
import "../Widgets" as Widgets

Item {
    id: root

    property alias landingPageComponent: landingPageComponent
    property alias homePageComponent: homePageComponent
    property alias infoPageComponent: infoPageComponent
    property alias menuItemComponent: menuItemComponent
    property alias cameraComponent: cameraComponent

    // Pages
    Component {
        id: landingPageComponent

        LandingPages.LandingPage {}
    }

    Component {
        id: homePageComponent

        HomePages.HomePage {}
    }

    Component {
        id: infoPageComponent

        InfoPages.InfoPage {}
    }

    Component {
        id: menuItemComponent

        Widgets.MenuItem {}
    }

    Component {
        id: cameraComponent

        Camera {

        }
    }
}
