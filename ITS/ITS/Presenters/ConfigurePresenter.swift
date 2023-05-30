//
//  ConfigurePresenter.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import Foundation


protocol ConfigurePresenterOutput: AnyObject {
    func updateNetworks(networks: [Network])
    func disableSetup()
    func enableSetup()
    func showAlert(message: String)
    func startLoading()
    func stopLoading()
    func disableReload()
    func enableReload()
    func goToCreate()
}


final class ConfigurePresenter {
    private weak var output: ConfigurePresenterOutput?
    private lazy var model = ConfigureModel(output: self)
    private var pingTimer: Timer?
    
    init(output: ConfigurePresenterOutput) {
        self.output = output
    }
    
    func didLoadView() {
        output?.disableReload()
        output?.startLoading()
        updateNetworks()
    }
    
    func didUpdateNetworks() {
        output?.disableReload()
        output?.startLoading()
        updateNetworks()
    }
    
    func didSetupNetwork(name: String, password: String) {
        output?.disableSetup()
        model.setupNetwork(name: name, password: password) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let response):
                    print(response.status)
                    self?.startPing()
                case .failure(let configError):
                    self?.showAlert(of: configError)
                }
            }
        }
    }
    
    private func startPing() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
            self?.model.getStatusConnect { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response.status)
                        if response.status != .connecting {
                            self?.stopPing()
                            if response.status == .connected {
                                self?.output?.goToCreate()
                            } else {
                                self?.output?.enableSetup()
                                self?.showAlert(of: response.status)
                            }
                        }
                    case .failure(let configError):
                        self?.showAlert(of: configError)
                    }
                }
            }
        })
    }
    
    private func stopPing() {
        pingTimer?.invalidate()
    }
    
    private func updateNetworks() {
        model.getAvailableNetworks { [weak self] result in
            DispatchQueue.main.async {
                self?.output?.stopLoading()
                self?.output?.enableReload()
                switch result {
                case .success(let networks):
                    self?.output?.updateNetworks(networks: networks)
                    
                case .failure(let configError):
                    self?.showAlert(of: configError)
                }
            }
        }
    }
    
    private func showAlert(of error: ConfigureError) {
        switch error {
        case .deviceDisconnected:
            output?.showAlert(message: "You are not connected to Device")
        case .wifiDisconnected:
            output?.showAlert(message: "You have no connection to Wi-Fi")
        case .scanNotComplete:
            output?.showAlert(message: "Device is scanning networks")
        case .somethingWrong:
            output?.showAlert(message: "Something went wrong")
        }
    }
    
    private func showAlert(of status: SetupStatus) {
        switch status {
        case .connected:
            output?.showAlert(message: "Device connected to Wi-Fi!")
        case .connectFailed, .disconnected:
            output?.showAlert(message: "Connection to Wi-Fi failed")
        case .noSsidAvailable:
            output?.showAlert(message: "There is no Wi-Fi with that name")
        case .wrongPassword:
            output?.showAlert(message: "Wrong password")
        default:
            return
        }
    }
}


extension ConfigurePresenter: ConfigureModelOutput {
    
}

