//
//  DatabaseManager.swift
//  ITS
//
//  Created by Natalia on 13.12.2022.
//

import UIKit
import FirebaseFirestore
import Firebase

protocol DatabaseManagerDescription {
    func getCurrentUser() -> String
    
    func loadDevices(user: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void)
    func addDevice(user: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void)
    func delDevice(user: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void)
    func seeAllDevices(user: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void)
    
    func loadGroups(user: String, completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void)
    func addGroup(user: String, group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void)
    func delGroup(user: String, group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void)
    func seeAllGroups(user: String, completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void)
    
    func loadDevicesInGroup(user: String, group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void)
    func addDeviceToGroup(user: String, group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void)
    func delDeviceFromGroup(user: String, group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void)
    func seeDevicesInGroup(user: String, group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void)
}

enum DatabaseManagerError: Error {
    case noDocuments
}

class DatabaseManager: DatabaseManagerDescription {
    
    static let shared = DatabaseManager()
    
    private func configureFB() -> Firestore {
        
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        return db
        
    }
    
    func getCurrentUser() -> String {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            
            let user =  Auth.auth().currentUser
            
            if let user = user {
                return user.email!
            } else {
                return ""
            }
            
        }
        
        return ""
    }
    
    // MARK: - devices
    
    func loadDevices(user: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        let db = configureFB()
        
        db.collection("users").document(user).collection("allDevices")
            .addSnapshotListener { snap, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let devices = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            var devicesList = [DeviceCellViewObject]()
            
            for device in devices {
                let data = device.data()
                let name = data["name"] as! String
                let model = DeviceCellViewObject.init(name: name)
                devicesList.append(model)
            }
            
            completion(.success(devicesList))
        }
    }
    
    func addDevice(user: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let db = configureFB()
        let name: String = device.dict()["name"] as! String
        
        db.collection("users").document(user).collection("allDevices").document(name).setData(["name": name])
        
    }
    
    func delDevice(user: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let db = configureFB()
        let name: String = device.dict()["name"] as! String
        
        db.collection("users").document(user).collection("allDevices").document(name).delete()
        
    }
    
    func seeAllDevices(user: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        let db = configureFB()
        var devicesList: [DeviceCellViewObject] = []
        
        db.collection("users").document(user).collection("allDevices").getDocuments { snap, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let devices = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            for device in devices {
                let data = device.data()
                let name = data["name"] as! String
                let model = DeviceCellViewObject.init(name: name)
                devicesList.append(model)
                
            }
            
            completion(.success(devicesList))
            
        }

    }
    
    // MARK: - groups
    
    func loadGroups(user: String, completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void) {
        
        let db = configureFB()
        
        db.collection("users").document(user).collection("allGroups").addSnapshotListener { snap, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let groups = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            var groupsList = [GroupCellViewObject]()
            
            for group in groups {
                let data = group.data()
                let name = data["name"] as! String
                let devices = data["devices"] as! [String]
                let model = GroupCellViewObject.init(name: name, devices: devices)
                groupsList.append(model)
            }
            
            completion(.success(groupsList))
        }
    }
    
    func addGroup(user: String, group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let db = configureFB()
        let name: String = group.dict()["name"] as! String
        let devices: [String] = group.dict()["devices"] as! [String]
        
        db.collection("users").document(user).collection("allGroups").document(name).setData(["name": name, "devices": devices])
        
    }
    
    func delGroup(user: String, group: CreateGroupData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let db = configureFB()
        let name: String = group.dict()["name"] as! String
        
        db.collection("users").document(user).collection("allGroups").document(name).delete()
        
    }
    
    func seeAllGroups(user: String, completion: @escaping (Result<[GroupCellViewObject], Error>) -> Void) {
        
        let db = configureFB()
        var groupsList: [GroupCellViewObject] = []
        
        db.collection("users").document(user).collection("allGroups").getDocuments { snap, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let groups = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            for group in groups {
                let data = group.data()
                let name = data["name"] as! String
                let model = GroupCellViewObject.init(name: name, devices: [])
                groupsList.append(model)
                
            }
            
            completion(.success(groupsList))
            
        }
    }
    
    // MARK: - devices in group
    
    func loadDevicesInGroup(user: String, group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        
        let db = configureFB()
        
        db.collection("users").document(user).collection("allGroups").addSnapshotListener { snap, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let groups = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            var devicesList = [DeviceCellViewObject]()
            
            for g in groups {
                let data = g.data()
                let name = data["name"] as! String
                
                if (name == group) {
                    let devices = data["devices"] as! [String]
                    
                    for device in devices {
                        let model = DeviceCellViewObject.init(name: device)
                        devicesList.append(model)
                    }
                    
                    break
                }
            }
            
            completion(.success(devicesList))
        }
    }
    
    func addDeviceToGroup(user: String, group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {

        let db = configureFB()
        var devicesList: [String] = []
        
        db.collection("users").document(user).collection("allGroups").getDocuments { snap, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let groups = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            for g in groups {
                let data = g.data()
                let name = data["name"] as! String
                
                if (name == group) {
                    let devices = data["devices"] as! [String]
                    
                    for d in devices {
                        devicesList.append(d)
                    }
                    
                    devicesList.append(device.dict()["name"] as! String)
                    
                    break
                }
            }
            
            db.collection("users").document(user).collection("allGroups").document(group).updateData(["devices": devicesList])
            
        }

    }

    func delDeviceFromGroup(user: String, group: String, device: CreateDeviceData, completion: @escaping (Result<Void, Error>) -> Void) {

        let db = configureFB()
        var devicesList: [String] = []
        
        db.collection("users").document(user).collection("allGroups").getDocuments { snap, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let groups = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            for g in groups {
                let data = g.data()
                let name = data["name"] as! String
                
                if (name == group) {
                    let devices = data["devices"] as! [String]
                    
                    for d in devices {
                        if d != device.dict()["name"] as! String {
                            devicesList.append(d)
                        }
                    }
                    
                    break
                }
            }
            
            db.collection("users").document(user).collection("allGroups").document(group).updateData(["devices": devicesList])
            
        }
    }
    
    func seeDevicesInGroup(user: String, group: String, completion: @escaping (Result<[DeviceCellViewObject], Error>) -> Void) {
        let db = configureFB()
        
        db.collection("users").document(user).collection("allGroups").getDocuments { snap, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let groups = snap?.documents else {
                completion(.failure(DatabaseManagerError.noDocuments))
                return
            }
            
            var devicesList = [DeviceCellViewObject]()
            
            for g in groups {
                let data = g.data()
                let name = data["name"] as! String
                
                if (name == group) {
                    let devices = data["devices"] as! [String]
                    
                    for device in devices {
                        let model = DeviceCellViewObject.init(name: device)
                        devicesList.append(model)
                    }
                    
                    break
                }
            }
            
            completion(.success(devicesList))
        }
    }
}
