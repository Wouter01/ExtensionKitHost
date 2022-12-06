//
//  File.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation
import ExtensionFoundation
import ConcurrencyPlus

public struct HostTransformer: Transformable, XPCTransferable {
    typealias XPCType = XPCTransformable
    public var connection: NSXPCConnection

    public init(process: AppExtensionProcess) throws {
        connection = try process.makeXPCConnection()
        connection.remoteObjectInterface = .init(with: XPCType.self)
    }

    public func reverse(@Encoded _ input: String) async throws -> String {
        guard let $input else { throw XPCError.encodeError }

        return await withConnection {
            try! await connection.withContinuation { (service: XPCType, continuation) in
                service.reverse($input, reply: continuation.resumingHandler)
            }
        }
    }

    public func replace(@Encoded _ input: String, @Encoded with: Hello) async throws -> String {
        guard let $input, let $with else { throw XPCError.encodeError }

        return await withConnection {
            try! await connection.withContinuation { (service: XPCType, continuation) in
                service.replace($input, with: $with, reply: continuation.resumingHandler)
            }
        }
    }

    public func save(_ input: String, to: URL, override: Bool) async throws -> Result<URL, Error> {
        await withConnection {
            await Result {
                try await connection.withContinuation { (service: XPCType, continuation) in
                    service.save(input, to: to, override: override, reply: continuation.resumingHandler)
                }
            }
        }
    }
}
