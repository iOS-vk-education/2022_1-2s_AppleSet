//
//  SearchPresenter.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import UIKit

protocol SearchPresenterOutput: AnyObject {
    func startLoading()
    func stopLoading()
    func showSuccess()
    func showAlert(message: String)
    func disableConnect()
    func enableConnect()
}

final class SearchPresenter {
    private weak var output: SearchPresenterOutput?
    private lazy var model = SearchModel(output: self)
    
    init(output: SearchPresenterOutput) {
        self.output = output
    }
    
    func didLoadView() {
        
    }
    
    func didTapSettings() {
        guard
            let settingsUrl = URL(string: "App-prefs:root=WIFI"),
            UIApplication.shared.canOpenURL(settingsUrl)
        else {
            return
        }
        
        UIApplication.shared.open(settingsUrl)
    }
    
    func didTapConnect() {
        output?.disableConnect()
        output?.startLoading()
        model.checkConnectionToDevice { [weak self] result in
            switch result {
            case .success(let settings):
                DevicesManager.shared.createTempDevice(with: settings.id, type: settings.type) { isExist in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self?.output?.stopLoading()
                        if isExist {
                            self?.output?.showAlert(message: "This device is exist")
                        } else {
                            self?.output?.showSuccess()
                        }
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.output?.stopLoading()
                    self?.output?.enableConnect()
                    self?.showAlert(of: error)
                }
                
            }
        }
    }
    
    private func showAlert(of error: SearchError) {
        switch error {
        case .deviceDisconnected:
            output?.showAlert(message: "You are not connected to Device")
        case .wifiDisconnected:
            output?.showAlert(message: "You have no connection to Wi-Fi")
        case .somethingWrong:
            output?.showAlert(message: "Something went wrong")
        }
    }
}

extension SearchPresenter: SearchModelOutput {
    
}

