//
//  File.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation
import ExtensionFoundation

public protocol TransformExtension: AppExtension, Transformable {}

public struct Config: AppExtensionConfiguration {
    public var guest: any TransformExtension

    public init(guest: any TransformExtension) {
        self.guest = guest
    }

    public func accept(connection: NSXPCConnection) -> Bool {
        connection.exportedInterface = .init(with: XPCTransformable.self)
        connection.exportedObject = GuestTransformer(guest: guest)
        connection.resume()
        return true
    }
}

public extension TransformExtension {
    var configuration: Config { Config(guest: self) }
}
