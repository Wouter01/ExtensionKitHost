//
//  File 2.swift
//  
//
//  Created by Wouter Hennen on 05/12/2022.
//

import Foundation

func mapToXPC<T: Decodable,V: Encodable>(xpcFrom: Data, invocation: @escaping (T) async throws -> V, reply: @escaping (Data?, Error?) -> Void) {
    Task {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: xpcFrom)
            let result = try await invocation(decoded)
            let encoded = try JSONEncoder().encode(result)
            reply(encoded, nil)
        } catch {
            reply(nil, error)
        }
    }
}

func mapToXPC<T: Decodable, U: Decodable,V: Encodable>(arg1: Data, arg2: Data, invocation: @escaping (T, U) async throws -> V, reply: @escaping (Data?, Error?) -> Void) {
    Task {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: arg1)
            let decoded2 = try JSONDecoder().decode(U.self, from: arg2)
            let result = try await invocation(decoded, decoded2)
            let encoded = try JSONEncoder().encode(result)
            reply(encoded, nil)
        } catch {
            reply(nil, error)
        }
    }
}

protocol XPCTranferableHelper {
    associatedtype Guest

    var guest: Guest { get }
    
    static var encoder: JSONEncoder { get }
    static var decoder: JSONDecoder { get }
}

extension XPCTranferableHelper {
    static var encoder: JSONEncoder { .init() }
    static var decoder: JSONDecoder { .init() }
}

extension XPCTranferableHelper {
    static func extCall<Arg1: Decodable, Ret: Encodable>(@Decoded<Arg1> arg1: Data, invocation: @escaping (Arg1) async throws -> Ret, reply: @escaping (Data?, Error?) -> Void) {
        guard let $arg1 else {
            reply(nil, XPCError.decodeError)
            return
        }
        Task {
            do {
                let result = try await invocation($arg1)
                let resultEncoded = try encoder.encode(result)
                reply(resultEncoded, nil)
            } catch {
                reply(nil, error)
            }
        }
    }

    static func extCall<Arg1: Decodable, Arg2: Decodable, Ret: Encodable>(@Decoded<Arg1> arg1: Data, @Decoded<Arg2> arg2: Data, invocation: @escaping (Arg1, Arg2) async throws -> Ret, reply: @escaping (Data?, Error?) -> Void) {
        guard let $arg1, let $arg2 else {
            reply(nil, XPCError.decodeError)
            return
        }

        Task {
            do {
                let result = try await invocation($arg1, $arg2)
                let resultEncoded = try encoder.encode(result)
                reply(resultEncoded, nil)
            } catch {
                reply(nil, error)
            }
        }
    }

    static func extCall<Arg1: Decodable, Arg2: Decodable, Arg3: Decodable, Ret: Encodable>(@Decoded<Arg1> arg1: Data, @Decoded<Arg2> arg2: Data, @Decoded<Arg3> arg3: Data, invocation: @escaping (Arg1, Arg2, Arg3) async throws -> Ret, reply: @escaping (Data?, Error?) -> Void) {
        guard let $arg1, let $arg2, let $arg3 else {
            reply(nil, XPCError.decodeError)
            return
        }
        Task {
            do {
                let result = try await invocation($arg1, $arg2, $arg3)
                let resultEncoded = try encoder.encode(result)
                reply(resultEncoded, nil)
            } catch {
                reply(nil, error)
            }
        }
    }
}

