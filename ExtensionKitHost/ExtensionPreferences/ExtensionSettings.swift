//
//  ExtensionSettings.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import CodeEditKit

struct ExtensionSettings: View {
    var ext: CEExtension
    @State var enabled = true
    @State var metadata: (any SettingsExtension)?
    @State var noSettings = false
    var body: some View {
        if noSettings {
            VStack {
                Text("This extension has no settings")
            }
        } else {
            VStack(alignment: .leading, spacing: 5) {
                Group {
                    if let metadata {
                        Text(metadata.description)
                            .fontWeight(.semibold)
                        EntitlementsView(entitlements: metadata.entitlements)
                    } else {
                        ProgressView()
                            .controlSize(.small)
                    }
                }
                .padding(.horizontal, 20)


                ExtensionHostView(with: ext)
                    .navigationTitle(ext.localizedName)
                    .navigationSubtitle(ext.bundleIdentifier)
                    .accentColor(enabled ? .blue : .red)
//                    .ceEnvironment(\.complexValue, enabled ? ["Halloeee"] : [])
//                    .ceEnvironment(\.testkey, enabled)
//                    .ceEnvironment(\.testkey2, !enabled)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Toggle("", isOn: $enabled)
                                .toggleStyle(.switch)
                                .labelsHidden()
                        }
                    }
                    .task(id: ext) {
                        do {
                            let client = try CEXPCClient(with: .init(configuration: .init(appExtensionIdentity: ext)))
                            Task {
                                do {
                                    let result = try await client.getData()
                                    print("Got Result! \(result)")
                                    await MainActor.run {
                                        self.metadata = result
                                    }
                                } catch {
                                    noSettings = true
                                    print(error)
                                }
                            }
                        } catch {
                            noSettings = true
                            print(error)
                        }
                    }
            }
        }
    }
}
