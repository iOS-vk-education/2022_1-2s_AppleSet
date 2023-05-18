//
//  DevicesManager.swift
//  ITS
//
//  Created by Всеволод on 11.04.2023.
//

import Foundation

struct SmartLight {
    var name: String
    var deviceID: String
    var state: State = .disconnected
    var mode: Mode?
    var brightness: UInt8?
    var color: String?
    
    enum State: String {
        case on
        case off
        case disconnected
        
        mutating func switchState() {
            if self == .on {
                self = .off
            } else if self == .off {
                self = .on
            } else {
                return
            }
        }
    }
    
    enum Mode: String, CaseIterable {
        case light
        case multicolor
//        case rainbow
    }
    
    enum Function: String, CaseIterable {
        case state
        case brightness
        case color
        case mode
    }
}

struct AirController {
    var name: String
    var deviceID: String
    var state: State = .disconnected
    var temperature: Float?
    var humidity: Float?
    var pressure: Float?
    var height: Float?
    
    enum State {
        case connected
        case disconnected
    }
    
    enum Function: String, CaseIterable {
        case temperature
        case humidity
        case pressure
        case height
    }
}

private struct None {
    var name: String
    var deviceID: String
}

struct DeviceData {
    var name: String
    var deviceType: CreateDeviceData.DeviceType
    var deviceID: String
}

protocol DevicesManagerDescription {
    func loadDevicesData()
    func getTypeByName(name: String) -> CreateDeviceData.DeviceType?
    func getSmartLightStatus(name: String) -> SmartLight?
    func getAirControllerStatus(name: String) -> AirController?
    func updateSmartLightStatus(status: SmartLight)
    func updateAirControllerStatus(status: AirController)
}


final class DevicesManager: DevicesManagerDescription {
    static let shared: DevicesManagerDescription = DevicesManager()
    private let manager = DatabaseManager()
    private var deviceTypes = [String : CreateDeviceData.DeviceType]()
    private var smartLights = [String : SmartLight]()
    private var airControllers = [String : AirController]()
    
    
    private init() {}
    
    func loadDevicesData() {
        let user = manager.getCurrentUser()
        
        manager.loadDevicesData(user: user, completion: { result in
            switch result {
            case .success(let devices):
                devices.forEach { device in
                    guard self.deviceTypes[device.name] == nil else {
                        return
                    }
                    
                    self.deviceTypes[device.name] = device.deviceType
                    
                    switch device.deviceType {
                    case .SmartLight:
                        self.smartLights[device.name] = .init(name: device.name, deviceID: device.deviceID)
                    case .AirControl:
                        self.airControllers[device.name] = .init(name: device.name, deviceID: device.deviceID)
                    case .None:
                        return
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getTypeByName(name: String) -> CreateDeviceData.DeviceType? {
        guard let type = deviceTypes[name] else {
            return nil
        }
        
        return type
    }
    
    func getSmartLightStatus(name: String) -> SmartLight? {
        guard let smartLight = smartLights[name] else {
            return nil
        }
        
        return smartLight
    }
    
    func getAirControllerStatus(name: String) -> AirController? {
        guard let airController = airControllers[name] else {
            return nil
        }
        
        return airController
    }
    
    func updateSmartLightStatus(status: SmartLight) {
        smartLights[status.name] = status
    }
    
    func updateAirControllerStatus(status: AirController) {
        airControllers[status.name] = status
    }
}
