//
//  DevicesManager.swift
//  ITS
//
//  Created by Всеволод on 11.04.2023.
//

import Foundation

private struct SmartLight {
    var name: String
    var deviceID: String
    var state: State = .disconnected
    var bright: UInt8?
    var color: (Int, Int, Int, Int)?
    var mode: String?
    
    enum State: String {
        case on
        case off
        case disconnected
        
        mutating func switchState() {
            if self == .on {
                self = .off
            } else if self == .off {
                self = .on
            }
        }
    }
}


final class DevicesManager {
    static let shared = DevicesManager()
    
    
    private init() {
        
    }
}
