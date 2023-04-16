//
//  AddDeviceAlertController.swift
//  ITS
//
//  Created by Всеволод on 11.04.2023.
//

import UIKit
import PinLayout



final class AddDeviceAlertController: UIViewController {
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let addButton = UIButton()
    private let cancelButton = UIButton()
    private let pickerView = UIPickerView()
    
    private var addAction: ((String, CreateDeviceData.DeviceType, String) -> Void)?
    
    private let deviceChoices = ["Smart Lightning", "Air controller", "None"]
    private var deviceType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceType = deviceChoices[0]
        setup()
    }
    
    private func setup() {
        alertView.backgroundColor = .customBackgroundColor
        alertView.layer.cornerRadius = 10
        
        titleLabel.text = "Add Device"
        titleLabel.font = UIFont(name: "Marker Felt", size: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.customBlue, for: .normal)
        addButton.backgroundColor = .customBackgroundColor
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.customBlue.cgColor
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.backgroundColor = .customBackgroundColor
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.systemRed.cgColor
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        textField.placeholder = "Name"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(textField)
        alertView.addSubview(pickerView)
        alertView.addSubview(addButton)
        alertView.addSubview(cancelButton)
        
        view.addSubview(alertView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        alertView.pin
            .vCenter()
            .hCenter()
            .width(view.frame.width - 100)
            .height(300)
        
        titleLabel.pin
            .top(20)
            .horizontally(10)
            .sizeToFit(.width)
        
        textField.pin
            .below(of: titleLabel)
            .marginTop(10)
            .horizontally(10)
            .height(32)
        
        pickerView.pin
            .below(of: textField)
            .marginTop(20)
            .width(alertView.frame.width - 20)
            .height(140)
        
        addButton.pin
            .bottomLeft()
            .width(alertView.frame.width / 2 - 20)
            .sizeToFit(.width)
        
        cancelButton.pin
            .bottomRight()
            .width(alertView.frame.width / 2 - 20)
            .sizeToFit(.width)
        
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapAddButton() {
        guard let addAction, let name = textField.text, !name.isEmpty else {
            return
        }
        
        var deviceID: String
        var type: CreateDeviceData.DeviceType
        if deviceType == deviceChoices[0] {
            deviceID = "device_97F4A9"
            type = .SmartLight
        } else if deviceType == deviceChoices[1] {
            deviceID = "device_479F7E"
            type = .AirControl
        } else {
            deviceID = UUID().uuidString
            type = .None
        }
        
        addAction(name, type, deviceID)
        dismiss(animated: true)
    }
    
    func onAddAction(completion: @escaping (String, CreateDeviceData.DeviceType, String) -> Void) {
        addAction = completion
    }
}

extension AddDeviceAlertController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deviceChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deviceChoices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deviceType = deviceChoices[row]
    }
}
