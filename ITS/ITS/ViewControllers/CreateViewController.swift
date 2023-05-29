//
//  CreateViewController.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import UIKit

final class CreateViewController: UIViewController {
    private let typeLabel = UILabel()
    private let nameTextField = UITextField()
    private let createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        title = "Create"
        view.backgroundColor = .white
        
        guard let tempDevice = DevicesManager.shared.getTempDevice() else {
            return
        }
        
        typeLabel.text = tempDevice.deviceType.rawValue
        typeLabel.font = .systemFont(ofSize: 24)
        typeLabel.textColor = .black
        typeLabel.textAlignment = .center
        
        nameTextField.placeholder = "Name"
        nameTextField.backgroundColor = .white
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.systemGray5.cgColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.addTarget(self, action: #selector(didNameChanged), for: .editingChanged)
        nameTextField.autocorrectionType = .no
        nameTextField.autocapitalizationType = .none
        
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(.gray, for: .highlighted)
        createButton.titleLabel?.font = .systemFont(ofSize: 32)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        disableCreateButton()
        
        view.addSubview(typeLabel)
        view.addSubview(nameTextField)
        view.addSubview(createButton)
    }
    
    @objc private func didNameChanged() {
        guard
            let text = nameTextField.text,
            !text.isEmpty,
            text.count > 3
        else {
            disableCreateButton()
            return
        }
        
        enableCreateButton()
    }
    
    @objc private func didTapCreateButton() {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Do you want to create device?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "YES", style: .default) { _ in
            guard let name = self.nameTextField.text else {
                return
            }
            
            DevicesManager.shared.updateTempDevice(with: name) { isExist in
                DispatchQueue.main.async { [weak self] in
                    if isExist {
                        let alert = UIAlertController(title: "Alert", message: "Device with this name is exist", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(ok)
                        self?.present(alert, animated: true)
                    } else {
                        DevicesManager.shared.finishCreate()
                    }
                }
            }
        }
        
        let no = UIAlertAction(title: "NO", style: .destructive)
        alert.addAction(ok)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
    
    private func disableCreateButton() {
        createButton.setTitleColor(.gray, for: .normal)
        createButton.isUserInteractionEnabled = false
    }
    
    private func enableCreateButton() {
        createButton.setTitleColor(.link, for: .normal)
        createButton.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        typeLabel.pin
            .top(view.safeAreaInsets.top + 100)
            .horizontally(32)
            .sizeToFit(.width)
        
        nameTextField.pin
            .below(of: typeLabel)
            .marginTop(40)
            .height(50)
            .horizontally(32)
        
        createButton.pin
            .below(of: nameTextField)
            .marginTop(40)
            .height(32)
            .horizontally()
    }
}
