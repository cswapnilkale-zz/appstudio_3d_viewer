import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import "../../Widgets" as Widgets

Page {
    id: homePage

    Material.background: colors.view_background

    property int total: 0
    property int nextStart: 1

    property bool isPageLoading: false
    property bool isNextPageLoading: false

    signal back()

    header: ToolBar {
        height: 56 * constants.scaleFactor
        Material.primary: colors.view_background
        Material.elevation: 0

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    anchors.fill: parent

                    text: strings.web_scenes
                    color: colors.white
                    font.family: fonts.avenirNextBold
                    font.pixelSize: 20 * constants.scaleFactor
                    elide: Text.ElideRight
                    clip: true

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    leftPadding: 16 * constants.scaleFactor
                    rightPadding: 16 * constants.scaleFactor
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 16 * constants.scaleFactor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: listView

                anchors.fill: parent
                spacing: 16 * constants.scaleFactor
                clip: true
                model: ListModel {}

                delegate: SceneDelegate {
                    id: delegate

                    width: Math.min(parent.width, appManager.maximumScreenWidth) - 32 * constants.scaleFactor
                    height: 104 * constants.scaleFactor
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: colors.black

                    onClicked: {
                        var infoPage = infoPageComponent.createObject(
                                    null,
                                    {
                                        sceneUrl: constants.orgUrl + "/home/item.html?id=" + itemId
                                    });
                        infoPage.onClosed.connect(function() {
                            stackView.pop();
                        })
                        stackView.push(infoPage);
                    }
                }

                footer: Widgets.ProgressIndicator {
                    width: parent.width
                    height: 56 * constants.scaleFactor
                    visible: isNextPageLoading
                }

                onAtYEndChanged: {
                    if (atYEnd && contentY > 0 && !isNextPageLoading && listView.model.count < total) {
                        isNextPageLoading = true;

                        populateList();
                    }
                }
            }
        }
    }

    Widgets.ProgressIndicator {
        anchors.fill: parent
        visible: isPageLoading
    }

    Component.onCompleted: {
        initialize();
    }

    function initialize() {
        isPageLoading = true;

        populateList();
    }

    function populateList() {
        var q = "web scene " + constants.q_filter;
        var num = constants.loadingNumber;
        var sortField = "";
        var sortOrder = "desc";

        var promise = new Promise(function(resolve, reject) {
            networkManager.requestWebScenes(q, num, nextStart, sortField, sortOrder, function(response) {
                try {
                    if (!homePage)
                        return;

                    var results = [];
                    var nextStart = 1;

                    if (response.hasOwnProperty("total"))
                        total = response.total;

                    if (response.hasOwnProperty("results"))
                        results = response.results;

                    if (response.hasOwnProperty("nextStart"))
                        nextStart = response.nextStart;

                    for (var i in results) {
                        var temp = results[i];

                        var itemId = "";
                        var itemOwner = "";
                        var itemTitle = "";
                        var itemThumbnail = "";

                        if (temp.hasOwnProperty("id"))
                            itemId = temp.id;

                        if (temp.hasOwnProperty("owner"))
                            itemOwner = temp.owner;

                        if (temp.hasOwnProperty("title"))
                            itemTitle = temp.title;

                        if (temp.hasOwnProperty("thumbnail"))
                            itemThumbnail = networkManager.rootUrl + "/content/items/" + itemId + "/info/" + temp.thumbnail;

                        var obj = {
                            itemId: itemId,
                            itemOwner: itemOwner,
                            itemTitle: itemTitle,
                            itemThumbnail: itemThumbnail
                        }

                        listView.model.append(obj);
                    }

                    resolve();
                } catch (e) {
                    reject("Error in  HomePage populateList::requestWebScenes: " + e);
                }
            })
        })

        promise.then(function() {
            isPageLoading = false;
            isNextPageLoading = false;
        }).catch(function(e) {
            console.error(e);
        })
    }
}
