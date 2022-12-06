//
//  ExtensionActivatorView.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import ExtensionFoundation
import ExtensionKit

struct ExtensionActivatorView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> some NSViewController {
        EXAppExtensionBrowserViewController()
    }

    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {

    }

    func makeCoordinator() -> () {

    }
}

