//
//  File.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation

class GuestTransformer: XPCTransformable, XPCTranferableHelper {

    var guest: any Transformable

    init(guest: any Transformable) {
        self.guest = guest
    }

    func reverse(_ input: Data, reply: @escaping (Data?, Error?) -> Void) {
        Self.extCall(arg1: input, invocation: guest.reverse, reply: reply)
    }

    func replace(_ input: Data, with: Data, reply: @escaping (Data?, Error?) -> Void) {
        Self.extCall(arg1: input, arg2: with, invocation: guest.replace, reply: reply)
    }

    func save(_ input: String, to: URL, override: Bool, reply: @escaping (URL?, Error?) -> Void) {
        Task {
            do {
                let result = try await guest.save(input, to: to, override: override).get()
                reply(result, nil)
            } catch {
                reply(nil, error)
            }
        }
    }
}
