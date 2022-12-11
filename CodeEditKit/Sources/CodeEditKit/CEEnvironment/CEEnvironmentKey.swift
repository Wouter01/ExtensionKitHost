//
//  File.swift
//  
//
//  Created by Wouter Hennen on 11/12/2022.
//

import SwiftUI

public protocol CEEnvironmentKey {

    /// The associated type representing the type of the environment key's
    /// value.
    associatedtype Value: Codable

    static var identifier: String { get }

    /// The default value for the environment key.
    static var defaultValue: Self.Value { get }
}

public extension CEEnvironmentKey {
    static var identifier: String {
        String(describing: Self.self)
    }
}
