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

    func makeNSViewController(context: Context) -> EXHostViewController {
        let controller = EXHostViewController()
        controller.delegate = context.coordinator
        controller.configuration = .some(.init(appExtension: appExtension, sceneID: CEExtensionScene.settings.id))
        print("make: \(context.environment._ceEnvironment)")
        context.coordinator.updateEnvironment(context.environment._ceEnvironment)
        return controller
    }

    func updateNSViewController(_ nsViewController: EXHostViewController, context: Context) {
        print("update: \(context.environment._ceEnvironment)")
        context.coordinator.updateEnvironment(context.environment._ceEnvironment)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public class Coordinator: NSObject, EXHostViewControllerDelegate {
        var isOnline: Bool = false
        var toPublish: Data?
        public var connection: NSXPCConnection?

        public func updateEnvironment(@Encoded _ value: _CEEnvironment) {
            guard let $value else { return }

            guard isOnline else {
                toPublish = $value
                return
            }

            print("update: sending...")

            Task {
                do {
                    try await connection!.withService { (service: EnvironmentPublisherObjc) in
                        service.publishEnvironment(data: $value)
                    }
                } catch {
                    print(error)
                }
            }
        }

        public func hostViewControllerWillDeactivate(_ viewController: EXHostViewController, error: Error?) {
            isOnline = false
        }

        public func hostViewControllerDidActivate(_ viewController: EXHostViewController) {
            isOnline = true
            do {
                self.connection = try viewController.makeXPCConnection()
                connection?.remoteObjectInterface = .init(with: EnvironmentPublisherObjc.self)
                connection?.resume()
                if let toPublish {
                    Task {
                        try! await connection?.withService { (service: EnvironmentPublisherObjc) in
                            service.publishEnvironment(data: toPublish)
                        }
                    }
                }
            } catch {
                print("Unable to create connection: \(String(describing: error))")
            }
        }
    }
}
