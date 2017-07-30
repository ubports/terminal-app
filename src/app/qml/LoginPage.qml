/*
 * Copyright (C) 2013, 2014, 2016 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Walter Garcia-Fontes <walter.garcia@upf.edu>
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
  id: pageHeader
  objectName: "loginPage"

  header: PageHeader {
  flickable: scrollView.flickableItem
  title: i18n.tr("Login")
}


    ScrollView {
        id: scrollView
        anchors.fill: parent

	       Column {
                  width: scrollView.width

            ListItem {
                ListItemLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    title.text: i18n.tr("Require login")
                    summary.text: i18n.tr("Enable or disable login at start")

		       Switch {
		                id: layoutSwitch
				SlotsLayout.position: SlotsLayout.Trailing
                                checked: settings.authReq
                    onClicked: {
                        settings.authReq = !settings.authReq;
                             }
	  		}
	            }
                 }
             }
        }
}
