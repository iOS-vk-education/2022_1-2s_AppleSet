//
//  AllDevicesModel.swift
//  ITS
//
//  Created by Natalia on 25.02.2023.
//

import Foundation
import UIKit

final class DevicesAndGroupsModel {
    
    private let manager: DatabaseManagerDescription =  DatabaseManager.shared
    lazy var user: String = manager.getCurrentUser()
    
    // Devices
    
    func loadDevices(completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        manager.loadDevices(user: self.user, completion: completion)
    }
    
    func addDevice(device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        manager.addDevice(user: self.user, device: device, completion: completion)
    }
    
    func delDevice(device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        manager.delDevice(user: self.user, device: device, completion: completion)
    }
    
    func seeAllDevices(completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        manager.seeAllDevices(user: self.user, completion: completion)
    }
    
    // Groups
    
    func loadGroups(completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void) {
        manager.loadGroups(user: self.user, completion: completion)
    }
    
    func addGroup(group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void) {
        manager.addGroup(user: self.user, group: group, completion: completion)
    }
    
    func delGroup(group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void) {
        manager.delGroup(user: self.user, group: group, completion: completion)
    }
    
    func seeAllGroups(completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void) {
        manager.seeAllGroups(user: self.user, completion: completion)
    }
    
    // Devices + Groups
    
    func loadDevicesInGroup(group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        manager.loadDevicesInGroup(user: self.user, group: group, completion: completion)
    }
    
    func addDeviceToGroup(group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        manager.addDeviceToGroup(user: self.user, group: group, device: device, completion: completion)
    }
    
    func delDeviceFromGroup(group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        manager.delDeviceFromGroup(user: self.user, group: group, device: device, completion: completion)
    }

    func seeDevicesInGroup(group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        manager.seeDevicesInGroup(user: self.user, group: group, completion: completion)
    }
}
