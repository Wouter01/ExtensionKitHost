//
//  File 2.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation

enum XPCError: Error, Codable {
    case decodeError
    case encodeError
    case other(String)
}
