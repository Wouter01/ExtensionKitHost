//
//  File.swift
//  
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import ExtensionKit
import ExtensionFoundation

/// The AppExtensionScene protocol to which this extension's scenes will conform.
/// This is typically defined by the extension host in a framework.
public protocol SettingsScene: AppExtensionScene {
    var sceneID: CEExtensionScene { get }
}

/// The AppExtension protocol to which this extension will conform.
/// This is typically defined by the extension host in a framework.
public protocol SettingsExtension: AppExtension, Codable {
    associatedtype Configuration = AppExtensionSceneConfiguration
    associatedtype Body: SettingsScene

    var description: String { get }
    var entitlements: [Entitlement] { get }

    var body: Body { get }
}

public extension SettingsExtension {
    var configuration: AppExtensionSceneConfiguration {
        AppExtensionSceneConfiguration(self.body, configuration: SettingsExtensionConfiguration(self))
    }
}

public struct SettingsExtensionConfiguration<E: SettingsExtension>: AppExtensionConfiguration {
    public func accept(connection: NSXPCConnection) -> Bool {
        do {
            let data = try JSONEncoder().encode(appExtension)

            connection.exportedInterface = .init(with: Wrappable.self)
            connection.exportedObject = DataWrapper(data: data)
            connection.resume()

            return true

        } catch {
            print(error)
            return false
        }
    }

    let appExtension: E

    /// Creates a default configuration for the given extension.
    /// - Parameter appExtension: An instance of your custom extension that conforms to the ``TextTransformExtension`` protocol.
    public init(_ appExtension: E) {
        self.appExtension = appExtension
    }
}

/// An AppExtensionScene that this extension can provide.
/// This is typically defined by the extension host in a framework.
public struct GeneralSettingsScene<Content: View>: SettingsScene {

    public var sceneID: CEExtensionScene = .settings

    @ViewBuilder
    let content: () -> Content

    public init(content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some AppExtensionScene {
        PrimitiveAppExtensionScene(id: sceneID.id) {
            Form {
                content()
            }
            .formStyle(.grouped)
        } onConnection: { connection in
            // TODO: Configure the XPC connection and return true
            return true
        }
    }
}


/////////////////
///
///

@_spi(CodeEditInternal)
public struct DefaultSettingsExtension: SettingsExtension, Codable {

    public var description: String
    public var entitlements: [Entitlement]

    public var body: some SettingsScene {
        GeneralSettingsScene {
            EmptyView()
        }
    }

    public init() {
        fatalError()
    }

    public init(description: String, entitlements: [Entitlement]) {
        self.description = description
        self.entitlements = entitlements
    }


}

