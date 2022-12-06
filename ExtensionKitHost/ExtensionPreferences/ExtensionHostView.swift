//
//  ExtensionView.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import ExtensionKit
import CodeEditKit

struct ExtensionHostView: NSViewControllerRepresentable {

    let appExtension: CEExtension

    init(with appExtension: CEExtension) {
        self.appExtension = appExtension
    }

    func makeNSViewController(context: Context) -> some NSViewController {
        let controller = EXHostViewController()
        controller.configuration = .some(.init(appExtension: appExtension, sceneID: CEExtensionScene.settings.id))
        return controller
    }

    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {

    }

    func makeCoordinator() -> () {
        
    }
}

