import QtQuick 2.9

import Esri.ArcGISRuntime 100.5

Item {
    id: root

    function changePointToLatitudeLongitude(point, format, decimalPlaces) {
        return CoordinateFormatter.toLatitudeLongitude(point, format, decimalPlaces);
    }
}
