//
//  ContentView.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import ExtensionFoundation
import CodeEditKit

struct ContentView: View {
    @State var input = ""
    @State var input2 = ""
    @State var input3 = ""
    @State var transformer: HostTransformer?
    @State var replaceWord: Hello = .hallo
    var body: some View {
        Form {
            HStack {
                TextField("", text: $input)

                Button("Reverse") {
                    Task {
                        await reverseInput()
                    }
                }
            }
            HStack {
                TextField("", text: $input2)
                Picker("", selection: $replaceWord) {
                    ForEach(Hello.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
                Button("Replace") {
                    Task {
                        await replaceInput()
                    }
                }
            }
            HStack {
                TextField("", text: $input3)
                Button("Save") {
                    Task {
                        await saveInput()
                    }
                }
            }
        }
        .controlSize(.large)
        .labelsHidden()
        .formStyle(.grouped)
        .padding()
        .task {
            for await identities in try! AppExtensionIdentity.matching(appExtensionPointIDs: ExtensionID.general.rawValue) {

                if let ext = identities.first {
                    self.transformer = try! await HostTransformer(process: .init(configuration: .init(appExtensionIdentity: ext)))
                }

            }
        }
    }

    func reverseInput() async {
        input = (try? await transformer?.reverse(input)) ?? input
    }

    func replaceInput() async {
        input2 = (try? await transformer?.replace(input2, with: replaceWord)) ?? input2
    }

    func saveInput() async {
        input3 = (try? await transformer?.save(input3, to: .applicationDirectory, override: true).get().absoluteString) ?? input3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
