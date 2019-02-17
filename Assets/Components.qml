import QtQuick 2.9

import "../Views/HomePages" as HomePages
import "../Views/LandingPages" as LandingPages
import "../Views/InfoPages" as InfoPages

Item {
    id: root

    property alias landingPageComponent: landingPageComponent
    property alias homePageComponent: homePageComponent
    property alias infoPageComponent: infoPageComponent

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
}
