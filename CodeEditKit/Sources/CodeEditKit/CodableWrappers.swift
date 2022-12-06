//
//  File 2.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation

@propertyWrapper
struct Encoded<T: Encodable> {
    var wrappedValue: T

    var errorDescription: String? {
        do {
            _ = try JSONEncoder().encode(wrappedValue)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    var projectedValue: Data? {
        try? JSONEncoder().encode(wrappedValue)
    }
}

@propertyWrapper
struct Decoded<T: Decodable> {
    var wrappedValue: Data

    var errorDescription: String? {
        do {
            _ = try JSONDecoder().decode(T.self, from: wrappedValue)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    var projectedValue: T? {
        try? JSONDecoder().decode(T.self, from: wrappedValue)
    }
}
