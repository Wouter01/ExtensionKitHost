//
//  File.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation
import ExtensionKit

public protocol Transformable {
    func reverse(_ input: String) async throws -> String

    func replace(_ input: String, with: Hello) async throws -> String

    func save(_ input: String, to: URL, override: Bool) async throws -> Result<URL, Error>
}

extension Transformable {
    typealias XPCType = XPCTransformable
}

public enum Hello: Codable, CaseIterable, CustomStringConvertible {
    case hello
    case bonjour
    case hallo

    public var description: String {
        switch self {
        case .hello:
            return "Hello"
        case .bonjour:
            return "Bonjour"
        case .hallo:
            return "Hallo"
        }
    }
}

@objc protocol XPCTransformable {
    func reverse(_ input: Data, reply: @escaping (Data?, Error?) -> Void)

    func replace(_ input: Data, with: Data, reply: @escaping (Data?, Error?) -> Void)

    func save(_ input: String, to: URL, override: Bool, reply: @escaping (URL?, Error?) -> Void)
}
