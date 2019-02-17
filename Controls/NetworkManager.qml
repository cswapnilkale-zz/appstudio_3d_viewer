import QtQuick 2.9

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Item {
    id: root

    property string rootUrl: "";

    property string token: "";

    function makeNetworkConnection(url, obj, callback, params) {
        var component = networkRequestComponent;
        var networkRequest = component.createObject(parent);
        networkRequest.url = url;
        networkRequest.callback = callback;
        networkRequest.params = params;
        networkRequest.send(obj);
    }

    function requestWebScenes(q, num, start, sortField, sortOrder, callback) {
        var url = rootUrl + "/search";

        var obj = {
            q: q,
            num: num,
            start: start,
            sortField: sortField,
            sortOrder: sortOrder,
            f: "json"
        };

        if (token > "")
            obj.token = token;

        makeNetworkConnection(url, obj, callback);
    }

    Component {
        id: networkRequestComponent

        NetworkRequest {
            property var callback
            property var params

            followRedirects: true
            ignoreSslErrors: true
            responseType: "json"
            method: "POST"

            onReadyStateChanged: {
                if (readyState == NetworkRequest.DONE) {
                    if (errorCode === 0)
                        callback(response, params, errorCode);
                    else
                        callback(response, params, errorCode);
                }
            }

            onError: {
                callback({}, params, -1);
            }
        }
    }
}
