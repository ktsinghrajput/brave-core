// Copyright 2023 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import BraveCore
import BraveNews
import BraveUI
import Preferences
import Strings
import SwiftUI

struct AdvancedShieldsSettingsView: View {
  @ObservedObject private var settings: AdvancedShieldsSettings
  @State private var showManageWebsiteData = false

  var openURLAction: ((URL) -> Void)?

  init(
    profile: Profile,
    tabManager: TabManager,
    feedDataSource: FeedDataSource,
    historyAPI: BraveHistoryAPI,
    p3aUtilities: BraveP3AUtils,
    clearDataCallback: @escaping AdvancedShieldsSettings.ClearDataCallback
  ) {
    self.settings = AdvancedShieldsSettings(
      profile: profile,
      tabManager: tabManager,
      feedDataSource: feedDataSource,
      historyAPI: historyAPI,
      p3aUtilities: p3aUtilities,
      clearDataCallback: clearDataCallback
    )
  }

  var body: some View {
    List {
      DefaultShieldsViewView(settings: settings)
      ClearDataSectionView(settings: settings)

      Section {
        Button {
          showManageWebsiteData = true
        } label: {
          // Hack to show the disclosure
          NavigationLink(
            destination: { EmptyView() },
            label: {
              LabelView(
                title: Strings.manageWebsiteDataTitle,
                subtitle: nil
              )
            }
          )
        }
        .buttonStyle(.plain)
        .listRowBackground(Color(.secondaryBraveGroupedBackground))
        .sheet(isPresented: $showManageWebsiteData) {
          ManageWebsiteDataView()
        }

        NavigationLink {
          PrivacyReportSettingsView()
        } label: {
          LabelView(
            title: Strings.PrivacyHub.privacyReportsTitle,
            subtitle: nil
          )
        }.listRowBackground(Color(.secondaryBraveGroupedBackground))
      }

      OtherPrivacySettingsSectionView(settings: settings)
    }
    .listBackgroundColor(Color(UIColor.braveGroupedBackground))
    .listStyle(.insetGrouped)
    .navigationTitle(Strings.braveShieldsAndPrivacy)
    .environment(
      \.openURL,
      .init(handler: { [openURLAction] url in
        openURLAction?(url)
        return .handled
      })
    )
  }
}
