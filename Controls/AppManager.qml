import QtQuick 2.9
import QtQuick.Controls 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Authentication 1.0

Item {
    id: root

    property real maximumScreenWidth: app.width > 1000 * constants.scaleFactor ? 800 * constants.scaleFactor : 568 * constants.scaleFactor

    property bool isiPhoneX: false
    property bool isUsingDefaultFont: false
    property bool isiOS: false
    property bool ismacOS: false
    property bool isAutoSignIn: false
    property bool isRTL: false
    property bool isCompactCanvas: app.width <= 496 * constants.scaleFactor
    property bool isRegularCanvas: app.width > 496 * constants.scaleFactor && app.width <= 800 * constants.scaleFactor

    property alias schema: schema

    QtObject {
        id: schema

        property string startButtonText: ""
        property string galleryWebSceneQuery: ""
        property string portalUrl: ""
        property color startButtonColor

        readonly property string defaultStartButtonText: strings.start_button
        readonly property string defaultGalleryWebSceneQuery: "type: web scene"
        readonly property string defaultPortalUrl: "https://www.arcgis.com"
        readonly property color defaultStartButtonColor: colors.blue
    }

    function initialize() {
        // check device
        isiPhoneX = AppFramework.systemInformation.model.indexOf("iPhone X") > -1;
        isiOS = Qt.platform.os === "ios";
        ismacOS = Qt.platform.os === "osx";
        isRTL = AppFramework.localeInfo().esriName === "ar" || AppFramework.localeInfo().esriName === "he";

        // load properties
        loadAppSchema();

        // load font
        if (!isUsingDefaultFont)
            fonts.loadFonts();
    }

    function hasLocationPermission() {
        return AppFramework.checkCapability(AppFramework.Location);
    }

    function loadAppSchema() {
        schema.startButtonText = app.info.propertyValue("startButtonText", schema.defaultStartButtonText);
        schema.galleryWebSceneQuery = app.info.propertyValue("galleryWebSceneQuery", schema.defaultGalleryWebSceneQuery);
        schema.startButtonColor = app.info.propertyValue("startButtonColor", schema.defaultStartButtonColor);
        schema.portalUrl = app.info.propertyValue("portalUrl", schema.defaultPortalUrl);
    }
}
