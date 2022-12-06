//
//  ExtensionWindow.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI

struct ExtensionWindow: Scene {
    @State var showExtensionWindow = false
    @State var selectedExtension: CEExtension?

    var body: some Scene {
        Window("Extensions", id: "extensionWindow") {
            NavigationSplitView {
                ExtensionList(selectedExtension: $selectedExtension)
                    .toolbar {
                        Button {
                            showExtensionWindow.toggle()
                        } label: {
                            Image(systemName: "puzzlepiece.extension")
                        }
                        .popover(isPresented: $showExtensionWindow) {
                            ExtensionActivatorView()
                                .frame(width: 400)
                        }
                    }
            } detail: {
                if let selectedExtension {
                    ExtensionSettings(ext: selectedExtension)
                        .frame(minWidth: 100)
                        .id(selectedExtension)
                } else {
                    Text("Select an extension")
                }
            }
        }
    }
}
