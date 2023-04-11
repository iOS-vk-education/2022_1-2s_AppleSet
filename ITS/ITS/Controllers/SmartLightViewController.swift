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


private struct SmartLight {
    var state: State
    var bright: UInt8?
    var color: (Int, Int, Int, Int)?
    var mode: String?
    
    enum State: String {
        case on
        case off
        case disabled
        
        mutating func switchState() {
            if self == .on {
                self = .off
            } else if self == .off {
                self = .on
            }
        }
    }
}


final class SmartLightViewController: UIViewController {
    private lazy var presenter = SmartLightPresenter(output: self)
    private var smartLight = SmartLight(state: .disabled)
    
    private let loadLabel = UILabel()

    private let button = UIButton()
    private let brightSlider = UISlider()
    private let colorPicker = ChromaColorPicker()
    private let saturationSlider = ChromaBrightnessSlider()
    private let colorHandle = ChromaColorHandle()
    
    private let deviceID = "device_97F4A9"
    
    private var functionTopics: [String : String] = [
        "led" : "device_97F4A9/state",
        "brightness" : "device_97F4A9/bright",
        "color_red" : "device_97F4A9/color/red",
        "color_green" : "device_97F4A9/color/green",
        "color_blue" : "device_97F4A9/color/blue"
    ]
    
    private var statusTopics: [String : String] = [
        "led" : "device_97F4A9/state/status",
        "brightness" : "device_97F4A9/bright/status",
        "color_red" : "device_97F4A9/color/red/status",
        "color_green" : "device_97F4A9/color/green/status",
        "color_blue" : "device_97F4A9/color/blue/status"
    ]
    
    private var connectionTopics = [
        "ping" : "device_97F4A9/ping",
        "pong" : "device_97F4A9/pong",
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter.setup(with: deviceID)
        presenter.didLoadView(with: functionTopics, statusTopics: statusTopics, connectionTopics: connectionTopics)
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Smart Lightning"
        
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
        brightSlider.value = 50
        brightSlider.addTarget(self, action: #selector(didSliderValueChanged), for: .touchUpInside)
        setupSlider()
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        setupButton()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loadLabel.pin
            .vCenter()
            .horizontally(32)
            .sizeToFit(.width)
        
        colorPicker.pin
            .marginTop(view.safeAreaInsets.top + 100)
            .hCenter()
        
        saturationSlider.pin
            .below(of: colorPicker)
            .marginTop(30)
            .hCenter()
        
        button.pin
            .below(of: saturationSlider)
            .marginTop(30)
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
        
        presenter.send(from: .led, message: smartLight.state.rawValue)
    }
    
    @objc func didSliderValueChanged() {
        presenter.send(from: .brightness, message: String(Int(brightSlider.value)))
    }
    
    @objc func didColorValueChanged() {
        guard let rgb = colorHandle.color.rgb() else {
            return
        }
        
        guard let currentColor = smartLight.color else {
            smartLight.color = rgb
            return
        }
        
        if rgb != currentColor {
            smartLight.color = rgb
            print(currentColor)
        }
        
    }
    
    
    private func setupButton() {
        switch smartLight.state {
        case .off:
            button.setTitle("ON", for: .normal)
            button.setTitleColor(.systemBlue.withAlphaComponent(0.8), for: .normal)
        case .on:
            button.setTitle("OFF", for: .normal)
            button.setTitleColor(.systemRed.withAlphaComponent(0.8), for: .normal)
        case .disabled:
            button.setTitle("CHECKING...", for: .normal)
            button.setTitleColor(.systemGray3, for: .normal)
            button.isUserInteractionEnabled = false
        }
        button.layer.borderColor = button.currentTitleColor.cgColor
    }
    
    private func setupSlider() {
        switch smartLight.state {
        case .on:
            brightSlider.tintColor = .link
            brightSlider.isUserInteractionEnabled = true
        case .off:
            brightSlider.tintColor = .systemGray3
            brightSlider.isUserInteractionEnabled = false
        case .disabled:
            brightSlider.isUserInteractionEnabled = false
            brightSlider.tintColor = .systemGray3
        }
    }
    
}

extension SmartLightViewController: SmartLightPresenterOutput {
    
    func updateState(for function: SendFunction, message: String) {
        switch function {
        case .led:
            guard let state = SmartLight.State(rawValue: message) else {
                smartLight.state = .disabled
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
                brightSlider.value = Float(message)!
            }
        }
    }
    
    func setUIEnabled() {
        loadLabel.removeFromSuperview()
        
        view.addSubview(button)
        view.addSubview(brightSlider)
        view.addSubview(colorPicker)
        view.addSubview(saturationSlider)
        
        button.isUserInteractionEnabled = true
        brightSlider.isUserInteractionEnabled = true
        colorPicker.isUserInteractionEnabled = true
        saturationSlider.isUserInteractionEnabled = true
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


