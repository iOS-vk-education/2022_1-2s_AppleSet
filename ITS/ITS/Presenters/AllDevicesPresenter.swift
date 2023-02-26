//
//  AllDevicesPresenter.swift
//  ITS
//
//  Created by Natalia on 23.02.2023.
//

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
    }
}

extension AllDevicesPresenter {
    
    // Загружаем данные из БД
    private func loadDevices() {
        
        model.loadDevices { result in
            switch result {
            case .success(let devices):
                self.deviceCellViewObjects = devices
                self.output?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    func addDeviceCell(with name: String) {

        model.seeAllDevices { result in
            switch result {
            case .success(let devices):
                self.deviceCellViewObjects = devices

                for device in self.deviceCellViewObjects {
                    if device.name == name {
                        // Почему не работает???
                        self.output?.errorMessage(error: "This device was already add")
                        return
                    }
                }

                self.model.addDevice(device: CreateDeviceData(name: name)) { result in
                    switch result {
                    case .success:
                        self.output?.reloadData()
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

        model.delDevice(device: CreateDeviceData(name: name)) { result in
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
                                            self.model.delDeviceFromGroup(group: group.name, device: CreateDeviceData(name: name)) { result in
                                                switch result {
                                                case .success:
                                                    self.output?.reloadData()
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
