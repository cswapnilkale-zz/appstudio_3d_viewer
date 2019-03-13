import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import QtGraphicalEffects 1.0

import "../../Widgets" as Widgets

Drawer {
    id: root

    edge: appManager.isRTL ? Qt.LeftEdge : Qt.RightEdge

    interactive: this.visible

    background: Rectangle {
        anchors.fill: parent
        color: colors.view_background
    }

    property alias listView: listView

    signal clicked(var bookmarkViewpoint)

    onOpened: {
        this.forceActiveFocus();
    }

    onClosed: {
        app.forceActiveFocus();
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 56 * constants.scaleFactor

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredWidth: 56 * constants.scaleFactor
                        Layout.fillHeight: true

                        Widgets.IconImage {
                            width: 24 * constants.scaleFactor
                            height: this.width
                            anchors.centerIn: parent
                            source: images.book_marks_icon
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        text: strings.bookmarks
                        clip: true
                        elide: Text.ElideRight

                        font.family: fonts.avenirNextDemi
                        font.pixelSize: 16 * constants.scaleFactor
                        color: colors.white

                        horizontalAlignment: Label.AlignLeft
                        verticalAlignment: Label.AlignVCenter
                    }

                    Item {
                        Layout.preferredWidth: 16 * constants.scaleFactor
                        Layout.fillHeight: true
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: listView

                    anchors.fill: parent

                    model: ListModel {}

                    spacing: 0

                    visible: this.model.count > 0

                    delegate: Widgets.TouchGestureArea {
                        id: delegate

                        width: parent.width
                        height: 56 * constants.scaleFactor
                        color: colors.black

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.preferredWidth: 56 * constants.scaleFactor
                                Layout.fillHeight: true

                                Widgets.IconImage {
                                    width: 24 * constants.scaleFactor
                                    height: this.width
                                    anchors.centerIn: parent
                                    source: images.book_mark_icon
                                }
                            }

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                text: bookmarkName
                                clip: true
                                elide: Text.ElideRight

                                font.family: fonts.avenirNextDemi
                                font.pixelSize: 16 * constants.scaleFactor
                                color: colors.white

                                horizontalAlignment: Label.AlignLeft
                                verticalAlignment: Label.AlignVCenter
                            }

                            Item {
                                Layout.preferredWidth: 16 * constants.scaleFactor
                                Layout.fillHeight: true
                            }
                        }

                        onClicked: {
                            root.clicked(bookmarkViewpoint);
                        }
                    }
                }

                Label {
                    anchors.fill: parent

                    text: strings.empty_state_no_bookmarks
                    clip: true
                    elide: Text.ElideRight

                    font.family: fonts.avenirNextDemi
                    font.pixelSize: 16 * constants.scaleFactor
                    color: colors.white

                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    leftPadding: 16 * constants.scaleFactor
                    rightPadding: 16 * constants.scaleFactor
                }
            }
        }
    }
}
