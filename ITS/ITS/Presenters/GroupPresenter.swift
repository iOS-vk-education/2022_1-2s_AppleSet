//
//  GroupPresenter.swift
//  ITS
//
//  Created by Natalia on 26.02.2023.
//

protocol GroupPresenterOutput: AnyObject {
    func reloadData()
    func errorMessage(error: String)
}

class GroupPresenter {
    private let model: DevicesAndGroupsModel = DevicesAndGroupsModel()
    private weak var output: GroupPresenterOutput?
    
    var deviceCellViewObjects = [DeviceCellViewObject]()
    
    init(output: GroupPresenterOutput) {
        self.output = output
    }
    
    func didLoadView(group: String) {
        loadDevices(group: group)
    }
}

extension GroupPresenter {
    
    private func loadDevices(group: String) {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }
        
        model.loadDevicesInGroup(group: group) { result in
            switch result {
            case .success(let devices):
                self.deviceCellViewObjects = devices
                output.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addDeviceCell(with name: String, group: String) {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }
        
        model.seeDevicesInGroup(group: group) { result in
            switch result {
            case .success(let devices):
                self.deviceCellViewObjects = devices
                
                for device in self.deviceCellViewObjects {
                    if device.name == name {
                        output.errorMessage(error: "This device was already add to this group")
                        return
                    }
                }
                
                self.model.seeAllDevices { result in
                    switch result {
                    case .success(let allDevices):
                        
                        var is_dev = false
                        
                        for dev in allDevices {
                            if dev.name == name {
                                is_dev = true
                                break
                            }
                        }
                        
                        if (!is_dev) {
                            output.errorMessage(error: "Ther is not this device")
                            return
                        }
                        
                        self.model.addDeviceToGroup(group: group, device: CreateDeviceData(name: name, type: nil, deviceID: nil)) { result in
                            switch result {
                            case .success:
                                break
                            case .failure(let error):
                                print(error)
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                        return
                    }
                }
                
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func delDeviceCell(with name: String, group: String) {

        model.delDeviceFromGroup(group: group, device: CreateDeviceData(name: name, type: nil, deviceID: nil)) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }

        }
        
    }
    
}
