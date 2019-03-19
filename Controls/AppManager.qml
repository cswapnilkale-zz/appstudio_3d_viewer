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

    function initialize() {
        // check device
        isiPhoneX = AppFramework.systemInformation.model.indexOf("iPhone X") > -1;
        isiOS = Qt.platform.os === "ios";
        ismacOS = Qt.platform.os === "osx";
        isRTL = AppFramework.localeInfo().esriName === "ar" || AppFramework.localeInfo().esriName === "he";

        // load font
        if (!isUsingDefaultFont)
            fonts.loadFonts();
    }

    function hasLocationPermission() {
        return AppFramework.checkCapability(AppFramework.Location);
    }
}
