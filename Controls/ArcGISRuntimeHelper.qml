import QtQuick 2.9

import Esri.ArcGISRuntime 100.5

Item {
    id: root

    function changePointToLatitudeLongitude(point, format, decimalPlaces) {
        return CoordinateFormatter.toLatitudeLongitude(point, format, decimalPlaces);
    }

    function setCamera(sceneView, camera) {
        sceneView.setViewpointCamera(camera);
    }

    function cameraRotateAround(sceneView, point, deltaRotation) {
        var _camera = sceneView.currentViewpointCamera.rotateAround(
                    point,
                    deltaRotation.heading,
                    deltaRotation.pitch,
                    deltaRotation.roll);

        setCamera(sceneView, _camera);
    }
}
