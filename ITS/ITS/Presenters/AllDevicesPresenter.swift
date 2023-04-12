//
//  AllDevicesPresenter.swift
//  ITS
//
//  Created by Natalia on 23.02.2023.
//

import Foundation

protocol AllDevicesPresenterOutput: AnyObject {
    func reloadData()
    func errorMessage(error: String)
}

class AllDevicesPresenter {
    
    private let model: DevicesAndGroupsModel = DevicesAndGroupsModel()
    private weak var output: AllDevicesPresenterOutput?
    
    var deviceCellViewObjects = [DeviceCellViewObject]()
    
    init(output: AllDevicesPresenterOutput) {
        self.output = output
    }
    
    func didLoadView() {
        loadDevices()
        MQTTManager.shared.start()
        DevicesManager.shared.loadDevicesData()
    }
}

extension AllDevicesPresenter {
    
    // Загружаем данные из БД
    private func loadDevices() {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }
        
        model.loadDevices { result in
            switch result {
            case .success(let devices):
                self.deviceCellViewObjects = devices
                output.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
<<<<<<< HEAD
    func addDeviceCell(with data: CreateDeviceData) {
=======
    func addDeviceCell(with name: String) {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }
>>>>>>> prod

        model.seeAllDevices { result in
            switch result {
            case .success(let devices):
                self.deviceCellViewObjects = devices

                for device in self.deviceCellViewObjects {
<<<<<<< HEAD
                    if device.name == data.name {
                        // Почему не работает???
                        self.output?.errorMessage(error: "This device was already add")
=======
                    if device.name == name {
                        output.errorMessage(error: "This device was already add")
>>>>>>> prod
                        return
                    }
                }
                
                self.model.addDevice(device: data) { result in
                    switch result {
                    case .success:
                        output.reloadData()
                        break
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

    func delDeviceCell(with name: String) {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }

        model.delDevice(device: CreateDeviceData(name: name, type: nil, deviceID: nil)) { result in
            switch result {
            case .success:
                self.model.seeAllGroups { result in

                    switch result {
                    case .success(let groups):

                        for group in groups {

                            self.model.seeDevicesInGroup(group: group.name) { result in

                                switch result {
                                case .success(let devices):

                                    for device in devices{
                                        if device.name == name {
                                            self.model.delDeviceFromGroup(group: group.name, device: CreateDeviceData(name: name, type: nil, deviceID: nil)) { result in
                                                switch result {
                                                case .success:
                                                    output.reloadData()
                                                    break
                                                case .failure(let error):
                                                    print(error)
                                                    return
                                                }

                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                    return
                                }
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
}
