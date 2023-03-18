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
    let queue = DispatchQueue.global(qos: .utility)
    
    // Devices
    
    func loadDevices(completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.loadDevices(user: self.user, completion: completion)
        }
    }
    
    func addDevice(device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.addDevice(user: self.user, device: device, completion: completion)
        }
    }
    
    func delDevice(device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.delDevice(user: self.user, device: device, completion: completion)
        }
    }
    
    func seeAllDevices(completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            
            self.manager.seeAllDevices(user: self.user, completion: completion)
        }
    }
    
    // Groups
    
    func loadGroups(completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.loadGroups(user: self.user, completion: completion)
        }
    }
    
    func addGroup(group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.addGroup(user: self.user, group: group, completion: completion)
        }
    }
    
    func delGroup(group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.delGroup(user: self.user, group: group, completion: completion)
        }
    }
    
    func seeAllGroups(completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.seeAllGroups(user: self.user, completion: completion)
        }
    }
    
    // Devices + Groups
    
    func loadDevicesInGroup(group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.loadDevicesInGroup(user: self.user, group: group, completion: completion)
        }
    }
    
    func addDeviceToGroup(group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.addDeviceToGroup(user: self.user, group: group, device: device, completion: completion)
        }
    } 
    
    func delDeviceFromGroup(group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.delDeviceFromGroup(user: self.user, group: group, device: device, completion: completion)
        }
    }

    func seeDevicesInGroup(group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.seeDevicesInGroup(user: self.user, group: group, completion: completion)
        }
    }
}
