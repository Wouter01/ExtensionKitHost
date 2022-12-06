//
//  File.swift
//  
//
//  Created by Wouter Hennen on 06/12/2022.
//

import Foundation

extension Result where Failure == Error {
    public init(catching body: () async throws -> Success) async {
        do {
            self = .success(try await body())
        } catch {
            self = .failure(error)
        }
    }
}
