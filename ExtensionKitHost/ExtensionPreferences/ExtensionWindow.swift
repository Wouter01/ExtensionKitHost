//
//  ExtensionWindow.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import CodeEditKit

struct ExtensionWindow: Scene {
    @State var showExtensionWindow = false
    @State var selectedExtension: CEExtension?
    @State var textfield1: String = ""
    @State var textfield2: String = ""
    @State var showPopover = false
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

                        Button {
                            showPopover.toggle()
                        } label: {
                            Image(systemName: "gear")
                        }
                        .popover(isPresented: $showPopover) {
                            VStack {
                                TextField("", text: $textfield1)
                                    .textFieldStyle(.roundedBorder)
                                TextField("", text: $textfield2)
                                    .textFieldStyle(.roundedBorder)
                            }
                            .frame(minWidth: 200)
                            .padding()
                        }
                    }
            } detail: {
                if let selectedExtension {
                    ExtensionSettings(ext: selectedExtension)
                        .frame(minWidth: 100)
                        .id(selectedExtension)
                        .ceEnvironment(\.complexValue, [textfield1, textfield2])
                        .ceEnvironment(\.testkey, true)
                        .ceEnvironment(\.testkey2, false)
                } else {
                    Text("Select an extension")
                }
            }


        }
    }
}
