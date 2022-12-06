//
//  ExtensionManager.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import Foundation
import ExtensionKit
import ExtensionFoundation

enum ExtensionID: String {
    case general = "codeedit.kit.extension"
    case ui = "codeedit.kit.uiextension"
}

final class ExtensionManager: ObservableObject {

    @Published var extensions: [CEExtension] = []

    init() {
        Task {
            for await availability in AppExtensionIdentity.availabilityUpdates {
                print(availability)
            }
        }
    }

    func discover() async {
        do {
            let sequence = try AppExtensionIdentity.matching(appExtensionPointIDs: ExtensionID.general.rawValue, ExtensionID.ui.rawValue)
            for await identities in sequence {
                await MainActor.run {
                    self.extensions = identities
                }
            }
        } catch {
            print("Error while searching for extensions: \(error.localizedDescription)")
        }
    }
}
