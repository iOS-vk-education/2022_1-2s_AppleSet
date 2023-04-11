//
//  DeviceCellModel.swift
//  ITS
//
//  Created by Natalia on 26.11.2022.
//

import UIKit

final class DeviceCellViewObject {
    let name: String
    
    init(name: String = "") {
        self.name = name
    }
}

struct CreateDeviceData {
    let name: String
    let type: DeviceType?
    let deviceID: String?
    
    func dict() -> [String: Any] {
        return [
            "name": name,
            "type" : type?.rawValue as Any,
            "deviceID" : deviceID as Any
        ]
    }
    
    enum DeviceType: String {
        case SmartLight = "Smart Lightning"
        case AirControl = "Air Controller"
        case None
    }
}
