//
//  LampViewController.swift
//  ITS
//
//  Created by Всеволод on 09.04.2023.
//

import UIKit
import PinLayout
import CocoaMQTT
import ChromaColorPicker



final class SmartLightViewController: UIViewController {
    private lazy var presenter = SmartLightPresenter(output: self)
    private var smartLight: SmartLight = SmartLight(name: "some", deviceID: "some")
    
    private let loadLabel = UILabel()

    private let button = UIButton()
    private let brightSlider = UISlider()
    private let colorPicker = ChromaColorPicker()
    private let saturationSlider = ChromaBrightnessSlider()
    private let colorHandle = ChromaColorHandle()
    
    private let deviceID = "device_97F4A9"
    
    private var functionTopics: [String : String] = [
        "state" : "device_97F4A9/state",
        "brightness" : "device_97F4A9/bright",
        "color" : "device_97F4A9/color"
    ]
    
    private var statusTopics: [String : String] = [
        "state" : "device_97F4A9/state/status",
        "brightness" : "device_97F4A9/bright/status",
        "color" : "device_97F4A9/color/status"
    ]
    
    private var connectionTopics = [
        "ping" : "device_97F4A9/ping",
        "pong" : "device_97F4A9/pong",
    ]
    
    func configure(with name: String) {
        title = name
        
        guard let smartLight = DevicesManager.shared.getSmartLightState(name: name) else {
            return
        }
        
        self.smartLight = smartLight
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter.setup(with: deviceID)
        presenter.didLoadView(with: functionTopics, statusTopics: statusTopics, connectionTopics: connectionTopics)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        loadLabel.text = "CONNECTING..."
        loadLabel.font = UIFont(name: "Marker Felt", size: 26)
        loadLabel.textAlignment = .center
        loadLabel.textColor = .customRed
        
        colorPicker.frame = .init(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.width / 2)
        colorPicker.addTarget(self, action: #selector(didColorValueChanged), for: .touchUpInside)
        
        saturationSlider.frame = .init(x: 0, y: 0, width: view.frame.width - 100, height: 32)
        saturationSlider.addTarget(self, action: #selector(didColorValueChanged), for: .touchUpInside)
        colorPicker.connect(saturationSlider)
        
        colorHandle.color = .purple
        colorPicker.addHandle(colorHandle)
        
        brightSlider.minimumValue = 0
        brightSlider.maximumValue = 255
        brightSlider.addTarget(self, action: #selector(didSliderValueChanged), for: .touchUpInside)
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loadLabel.pin
            .vCenter()
            .horizontally(32)
            .sizeToFit(.width)
        
        colorPicker.pin
            .top(50)
            .hCenter()
        
        saturationSlider.pin
            .below(of: colorPicker)
            .marginTop(30)
            .hCenter()
        
        button.pin
            .below(of: saturationSlider)
            .marginTop(100)
            .height(32)
            .horizontally(32)
        
        brightSlider.pin
            .below(of: button)
            .marginTop(30)
            .horizontally(32)
    }
    
    @objc func didTapButton() {
        smartLight.state.switchState()
        
        setupButton()
        setupSlider()
        setupColorCircle()
        
        presenter.send(from: .state, message: smartLight.state.rawValue)
    }
    
    @objc func didSliderValueChanged() {
        presenter.send(from: .brightness, message: String(Int(brightSlider.value)))
    }
    
    @objc func didColorValueChanged() {
        guard let hex = colorHandle.color.toHex() else {
            return
        }
        
        guard let currentColor = smartLight.color else {
            smartLight.color = hex
            return
        }

        if hex != currentColor {
            smartLight.color = hex
            presenter.send(from: .color, message: hex)
        }
        
        
    }
    
    
    private func setupButton() {
        switch smartLight.state {
        case .off:
            button.setTitle("ON", for: .normal)
            button.setTitleColor(.systemBlue.withAlphaComponent(0.8), for: .normal)
            button.isUserInteractionEnabled = true
        case .on:
            button.setTitle("OFF", for: .normal)
            button.setTitleColor(.systemRed.withAlphaComponent(0.8), for: .normal)
            button.isUserInteractionEnabled = true
        case .disconnected:
            button.setTitle("CHECKING...", for: .normal)
            button.setTitleColor(.systemGray3, for: .normal)
            button.isUserInteractionEnabled = false
        }
        button.layer.borderColor = button.currentTitleColor.cgColor
    }
    
    private func setupSlider() {
        brightSlider.value = Float(smartLight.bright ?? 0)
        switch smartLight.state {
        case .on:
            brightSlider.tintColor = .link
            brightSlider.isUserInteractionEnabled = true
        case .off:
            brightSlider.tintColor = .systemGray3
            brightSlider.isUserInteractionEnabled = false
        case .disconnected:
            brightSlider.isUserInteractionEnabled = false
            brightSlider.tintColor = .systemGray3
        }
    }
    
    private func setupColorCircle() {
        colorHandle.color = UIColor(hex: smartLight.color ?? "FFFFFF")
        switch smartLight.state {
        case .on:
            colorPicker.isUserInteractionEnabled = true
            saturationSlider.isUserInteractionEnabled = true
        default:
            colorPicker.isUserInteractionEnabled = false
            saturationSlider.isUserInteractionEnabled = false
        }
    }
    
}

extension SmartLightViewController: SmartLightPresenterOutput {
    
    func getState() -> SmartLight.State {
        return smartLight.state
    }
    
    func updateState(for function: SendFunction, message: String) {
        switch function {
        case .state:
            guard let state = SmartLight.State(rawValue: message) else {
                smartLight.state = .disconnected
                setupButton()
                setupSlider()
                return
            }
            
            if smartLight.state != state {
                smartLight.state = state
                setupButton()
                setupSlider()
            }
            
        case .brightness:
            if message.isNumber {
                smartLight.bright = UInt8(message)!
                setupSlider()
            }
            
        case .color:
            guard smartLight.color != nil else {
                smartLight.color = message
                setupColorCircle()
                return
            }
            
            if smartLight.color != message {
                smartLight.color = message
                setupColorCircle()
            }
        }
        
        DevicesManager.shared.updateSmartLightState(state: smartLight)
    }
    
    func setUIEnabled() {
        loadLabel.removeFromSuperview()
        
        view.addSubview(button)
        view.addSubview(brightSlider)
        view.addSubview(colorPicker)
        view.addSubview(saturationSlider)
        
        setupButton()
        setupSlider()
    }
    
    func setUIDisabled() {
        button.isUserInteractionEnabled = false
        brightSlider.isUserInteractionEnabled = false
        colorPicker.isUserInteractionEnabled = false
        saturationSlider.isUserInteractionEnabled = false
    }
    
    func setDisconnected() {
        button.removeFromSuperview()
        brightSlider.removeFromSuperview()
        colorPicker.removeFromSuperview()
        saturationSlider.removeFromSuperview()
        
        view.addSubview(loadLabel)
    }
}


