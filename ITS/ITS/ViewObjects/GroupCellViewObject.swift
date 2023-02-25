//
//  PlaceCellModel.swift
//  ITS
//
//  Created by Natalia on 20.11.2022.
//

import UIKit

final class GroupCellViewObject {
    let name: String
    let devices: [String]
    
    init(name: String = "", devices: [String] = []) {
        self.name = name
        self.devices = devices
    }
}

struct CreateGroupData {
    let name: String
    let devices: [String]
    
    func dict() -> [String: Any] {
        return [
            "name": name,
            "devices": devices
        ]
    }
}
