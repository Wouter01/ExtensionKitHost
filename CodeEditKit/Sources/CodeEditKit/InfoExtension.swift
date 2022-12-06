//
//  File.swift
//  
//
//  Created by Wouter Hennen on 04/12/2022.
//

import Foundation
import ExtensionFoundation


public enum Entitlement: CustomStringConvertible, Codable, CaseIterable {
    case workspace
    case currentfile

    public var description: String {
        switch self {
        case .workspace:
            return "Workspace"
        case .currentfile:
            return "Current File"
        }
    }
}

@objc public protocol Wrappable {
    var data: Data { get }

    func getData(reply: @escaping (Data) -> Void)
}

public class DataWrapper: Wrappable {
    public var data: Data

    public func getData(reply: @escaping (Data) -> Void) {
        reply(data)
    }

    public init(data: Data) {
        self.data = data
    }
}
