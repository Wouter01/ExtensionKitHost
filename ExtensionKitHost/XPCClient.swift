//
//  XPCClient.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import Foundation
import ExtensionFoundation
@_spi(CodeEditInternal) import CodeEditKit
import sXPC

enum XPCError: Error, CustomStringConvertible {
    case communicationError
    case nilResponse

    var description: String {
        switch self {
        case .communicationError:
            return "Couldn't communicate with the extension"
        case .nilResponse:
            return "Extension returned nil response"
        }
    }
}

protocol XPCService {
    func errorMethod(reply: (Error?) -> Void)
    func valueAndErrorMethod(reply: (String?, Error?) -> Void)
    func dataAndErrorMethod(reply: (Data?, Error?) -> Void)
}



final class CEXPCClient: NSObject {

    let process: AppExtensionProcess

    public init(with process: AppExtensionProcess) {
        self.process = process
    }

    public func getData() async throws -> any SettingsExtension {
        var done = false

        let connection = try process.makeXPCConnection()

        connection.remoteObjectInterface = NSXPCInterface(with: Wrappable.self)

        connection.resume()

        
        /*
         Important note on bridging XPC callbacks and async/await:

         The reply block for an XPC method call may never be called in some circumstances,
         such as when the remote process dies before calling it.

         You may want to use something like `withCancellingContinuation`:
         https://github.com/ChimeHQ/ConcurrencyPlus
         */

        return try await withCheckedThrowingContinuation { continuation in
            guard let service = connection.remoteObjectProxyWithErrorHandler({ error in
                if !done {
                    continuation.resume(throwing: error)
                }
            }) as? Wrappable else {
                continuation.resume(throwing: XPCError.communicationError)
                return
            }

            service.getData { data in
                let info = try! JSONDecoder().decode(DefaultSettingsExtension.self, from: data)
                print(info)
                continuation.resume(returning: info)
            }

        }
    }




}
