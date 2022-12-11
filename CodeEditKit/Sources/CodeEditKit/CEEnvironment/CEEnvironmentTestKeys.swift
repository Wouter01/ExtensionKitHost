//
//  File.swift
//  
//
//  Created by Wouter Hennen on 11/12/2022.
//

import Foundation
import SwiftUI
import AnyCodable


public struct TestEnvKey: CEEnvironmentKey {
    public static var defaultValue = false
}

public struct TestEnvKey2: CEEnvironmentKey {
    public static var defaultValue = true
}

public extension _CEEnvironment {
    var testkey: TestEnvKey.Value {
        get {
            return self[TestEnvKey.self]
        }
        set {
            self[TestEnvKey.self] = newValue
        }
    }

    var testkey2: TestEnvKey2.Value {
        get {
            return self[TestEnvKey2.self]
        }
        set {
            self[TestEnvKey2.self] = newValue
        }
    }
}
