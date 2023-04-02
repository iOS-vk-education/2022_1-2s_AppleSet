//
//  MqttTestViewController.swift
//  ITS
//
//  Created by Всеволод on 27.03.2023.
//

import UIKit
import PinLayout
import CocoaMQTT


private enum ButtonState: String {
    case on = "on"
    case off = "off"
    case disabled
    
    mutating func switchState() {
        if self == .on {
            self = .off
        } else if self == .off {
            self = .on
        }
    }
}


final class MqttTestViewController: UIViewController {
    private lazy var presenter = MqttTestPresenter(output: self)
    
    private let disconnectedLabel = UILabel()
    
    private let tempLabel = UILabel()

    private let button = UIButton()
    private var buttonState: ButtonState = .disabled
    
    private let brightSlider = UISlider()
    
    private var functions: [String : String] = [
        "temperature" : "device_97F4A9/temp",
        "led" : "device_97F4A9/led",
        "brightness" : "device_97F4A9/led/bright",
    ]
    
    private var statusTopics: [String : String] = [
        "led" : "device_97F4A9/led/status",
        "brightness" : "device_97F4A9/led/bright/status",
    ]
    
    private var connectionTopics = [
        "ping" : "device_97F4A9/ping",
        "pong" : "device_97F4A9/pong",
    ]
    
    private var connectionTokens = [
        "ping" : "8CA3E512-CF14-47DB-AC17-7F578FBEE0A7",
        "ready_app" : "28D0E489-1A1D-43D3-9AA8-1570C05C8989",
        "pong" : "e72cf36f-f9c5-4dee-b11a-951c0e3dc638",
        "ready_device" : "a7f08e89-8c63-4d90-8c2d-f3fdb0b6f52e",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter.didLoadView(with: functions, statusTopics: statusTopics, connectionTopics: connectionTopics, connectionTokens: connectionTokens)
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Test"
        
        disconnectedLabel.text = "CONNECTING..."
        disconnectedLabel.font = UIFont(name: "Marker Felt", size: 26)
        disconnectedLabel.textAlignment = .center
        disconnectedLabel.textColor = .customRed
        
        tempLabel.text = "TEMP"
        tempLabel.font = UIFont(name: "Marker Felt", size: 24)
        tempLabel.textAlignment = .center
        tempLabel.textColor = .systemMint
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        setupButton()
        
        brightSlider.minimumValue = 0
        brightSlider.maximumValue = 100
        brightSlider.value = 50
        brightSlider.addTarget(self, action: #selector(didSliderValueChanged), for: .touchUpInside)
        setupSlider()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        disconnectedLabel.pin
            .vCenter()
            .horizontally(32)
            .sizeToFit(.width)
        
        tempLabel.pin
            .vCenter()
            .horizontally(32)
            .sizeToFit(.width)
        
        button.pin
            .below(of: tempLabel)
            .marginTop(30)
            .height(32)
            .horizontally(32)
        
        brightSlider.pin
            .below(of: button)
            .marginTop(30)
            .horizontally(32)
    }
    
    @objc func didTapButton() {
        buttonState.switchState()
        setupButton()
        setupSlider()
        presenter.sendMessage(from: .led, message: buttonState.rawValue)
    }
    
    @objc func didSliderValueChanged() {
        presenter.sendMessage(from: .brightness, message: String(Int(brightSlider.value)))
    }
    
    private func setupButton() {
        switch buttonState {
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
        switch buttonState {
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

extension MqttTestViewController: MqttTestPresenterOutput {
    func update(for function: ReceiveFunction, message: String) {
        switch function {
        case .temperature:
            tempLabel.text = message + " °C"
        }
    }
    
    func updateState(for function: SendFunction, message: String) {
        switch function {
        case .led:
            guard let state = ButtonState(rawValue: message) else {
                buttonState = .disabled
                setupButton()
                setupSlider()
                return
            }
            
            if buttonState != state {
                buttonState = state
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
        disconnectedLabel.removeFromSuperview()
        
        view.addSubview(tempLabel)
        view.addSubview(button)
        view.addSubview(brightSlider)
        
        button.isUserInteractionEnabled = true
        brightSlider.isUserInteractionEnabled = true
    }
    
    func setUIDisabled() {
        button.isUserInteractionEnabled = false
        brightSlider.isUserInteractionEnabled = false
    }
    
    func setDisconnected() {
        tempLabel.removeFromSuperview()
        button.removeFromSuperview()
        brightSlider.removeFromSuperview()
        
        view.addSubview(disconnectedLabel)
    }
}


