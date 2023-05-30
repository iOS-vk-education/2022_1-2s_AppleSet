//
//  GroupPresenter.swift
//  ITS
//
//  Created by Natalia on 26.02.2023.
//

import UIKit

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
        
        model.loadDevicesInGroup(group: group) { [weak self] result in
            switch result {
            case .success(let devices):
                print("load")
                self?.deviceCellViewObjects = devices
                DispatchQueue.main.async {
                    self?.output?.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addDeviceCells(devices: Set<String>, group: String) {
        devices.forEach { device in
            print(device)
            addDeviceCell(with: device, group: group)
        }
    }
    
    func addDeviceCell(with name: String, group: String) {
        
        model.addDeviceToGroup(group: group, device: CreateDeviceData(name: name, type: nil, deviceID: nil)) { result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
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
