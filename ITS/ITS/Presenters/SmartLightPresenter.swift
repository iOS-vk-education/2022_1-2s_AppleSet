//
//  LampPresenter.swift
//  ITS
//
//  Created by Всеволод on 09.04.2023.
//

import UIKit


protocol SmartLightPresenterOutput: AnyObject {
    func setConnected()
    func setConnecting()
    func setDisconnected()
    func setupMode(mode: SmartLight.Mode)
    func setupState(state: SmartLight.State)
    func setupColor(color: String)
    func setupBrightness(brightness: UInt8)
}

final class SmartLightPresenter {
    
    private weak var output: SmartLightPresenterOutput?
    private lazy var model = MQTTModel(output: self)
    private var smartLight: SmartLight?
    
    private var functionTopics: [SmartLight.Function : String] = [:]
    
    init(output: SmartLightPresenterOutput) {
        self.output = output
    }
    
    func setup(with deviceName: String) {
        guard let smartLight = DevicesManager.shared.getSmartLightStatus(name: deviceName) else {
            return
        }
        
        self.smartLight = smartLight
        model.setup(with: smartLight.deviceID)
        
        setFunctionTopics()
    }
    
    func didLoadView() {
        guard let smartLight else {
            return
        }
        
        if smartLight.state == .disconnected {
            output?.setConnecting()
            model.startConnecting(to: nil)
        } else {
            output?.setConnected()
            setupView()
        }
    }
    
    func didStateChanged() {
        smartLight?.state.switchState()
        
        guard let topic = functionTopics[.state],
              let state = smartLight?.state.rawValue
        else {
            return
        }
        model.send(message: state, to: topic)
        
        output?.setupState(state: smartLight?.state ?? .disconnected)
        
        guard let smartLight else {
            return
        }
        DevicesManager.shared.updateSmartLightStatus(status: smartLight)
    }
    
    func didModeSelected(mode: SmartLight.Mode) {
        smartLight?.mode = mode
        
        guard let topic = functionTopics[.mode] else {
            return
        }
        model.send(message: mode.rawValue, to: topic)
        
        output?.setupMode(mode: mode)
        
        guard let smartLight else {
            return
        }
        DevicesManager.shared.updateSmartLightStatus(status: smartLight)
    }
    
    func didColorChanged(color: UIColor) {
        guard let hex = color.toHex(),
              let currentColor = smartLight?.color,
              let topic = functionTopics[.color]
        else {
            return
        }

        if hex != currentColor {
            smartLight?.color = hex
            model.send(message: hex, to: topic)
            
            guard let smartLight else {
                return
            }
            DevicesManager.shared.updateSmartLightStatus(status: smartLight)
        }
    }
    
    func didBrightnessChanged(brightness: Float) {
        guard let topic = functionTopics[.brightness] else {
            return
        }
        
        model.send(message: String(Int(brightness)), to: topic)
        
        smartLight?.brightness = UInt8(brightness)
        
        guard let smartLight else {
            return
        }
        DevicesManager.shared.updateSmartLightStatus(status: smartLight)
    }
    
    func getSmartLightMode() -> SmartLight.Mode {
        return smartLight?.mode ?? .light
    }
    
    func getSmartLightState() -> SmartLight.State {
        return smartLight?.state ?? .disconnected
    }

    
    private func setFunctionTopics() {
        guard let smartLight else {
            return
        }
        
        SmartLight.Function.allCases.forEach { function in
            functionTopics[function] = smartLight.deviceID + "/\(function.rawValue)"
        }
    }
    
    private func setupView() {
        guard let smartLight else {
            return
        }
        output?.setupState(state: smartLight.state)
        guard let mode = smartLight.mode,
              let brightness = smartLight.brightness,
              let color = smartLight.color
        else {
            return
        }
        output?.setupMode(mode: mode)
        output?.setupBrightness(brightness: brightness)
        output?.setupColor(color: color)
    }
}

extension SmartLightPresenter: MQTTModelOutput {
    func updateStatus(with status: String) {
        output?.setConnected()
        
        let SLStatus = status.split(separator: "#").map { String($0) }
        smartLight?.state = SmartLight.State(rawValue: SLStatus[0]) ?? .disconnected
        smartLight?.mode = SmartLight.Mode(rawValue: SLStatus[1])
        smartLight?.brightness = UInt8(SLStatus[2])
        smartLight?.color = SLStatus[3]
        
        setupView()
        
        guard let smartLight else {
            return
        }
        DevicesManager.shared.updateSmartLightStatus(status: smartLight)
    }
    
    func setReady() {
        model.getStatus()
    }
    
    func setDisconnected() {
        print(#function)
    }
    
    
    
    //not realized in SmartLight
    func update(for topic: String, message: String) {
        return
    }
}
