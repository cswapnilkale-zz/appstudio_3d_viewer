import QtQuick 2.9

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Item {
    id: root

    property string rootUrl: "";

    property string token: "";

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

    function requestShortenedUrl(longUrl, callback) {
        var url = "https://arcg.is/prod/shorten?longUrl=" + longUrl;

        makeXHRRequest(url, "GET", callback);
    }

    function makeXHRRequest(networkRequestUrl, networkRequestMethod, callback) {
        var xhr = new XMLHttpRequest();
        var method = networkRequestMethod;
        var url = networkRequestUrl;

        xhr.open(method, url, true);
        xhr.send();

        xhr.onreadystatechange = function() {
            if (xhr.readyState === xhr.DONE && xhr.status === 200)
                callback(xhr);
        };
    }
}
