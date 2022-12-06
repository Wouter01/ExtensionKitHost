//
//  File 2.swift
//  
//
//  Created by Wouter Hennen on 05/12/2022.
//

import Foundation

protocol XPCTransferable {
    associatedtype XPCType
    var connection: NSXPCConnection { get }
}

extension XPCTransferable {
    @discardableResult @MainActor
    func withConnection<T>(_ body: () async throws -> T) async rethrows -> T  {
        connection.resume()
        let result = try await body()
        connection.suspend()
        return result
    }
}
