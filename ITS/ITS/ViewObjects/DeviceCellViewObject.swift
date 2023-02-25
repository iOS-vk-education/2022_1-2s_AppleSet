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
    
    func dict() -> [String: Any] {
        return [
            "name": name
        ]
    }
}
