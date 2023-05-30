//
//  AddDevicesToGroupViewController.swift
//  ITS
//
//  Created by Всеволод on 29.05.2023.
//

import UIKit
import PinLayout


protocol AddDevicesToGroupViewControllerOutput: AnyObject {
    func addDeviceCells(devices: Set<String>)
}


final class AddDevicesToGroupViewController: UIViewController {
    private weak var output: AddDevicesToGroupViewControllerOutput?
    private let tableView = UITableView()
    private let addButton = UIButton()
    private var devices = [(name: String, type: CreateDeviceData.DeviceType)]()
    private var selectedDevices = Set<String>() {
        didSet {
            if selectedDevices.count > 0 {
                enableAddButton()
            } else {
                disableAddButton()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavBar()
    }
    
    init(output: AddDevicesToGroupViewControllerOutput, name: String, existDevices: [DeviceCellViewObject]) {
        super.init(nibName: nil, bundle: nil)
        title = name
        
        self.output = output
        
        DevicesManager.shared.getDevices().forEach { device in
            if !existDevices.contains(where: { deviceViewObject in
                deviceViewObject.name == device.name
            }) {
                devices.append((device.name, device.type))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.register(DeviceToGroupCell.self, forCellReuseIdentifier: "DeviceToGroupCell")
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.link, for: .normal)
        addButton.setTitleColor(.gray, for: .highlighted)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        disableAddButton()
        
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    private func setupNavBar() {
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBackButton))
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func didTapAddButton() {
        output?.addDeviceCells(devices: selectedDevices)
        dismiss(animated: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.pin
            .top(view.safeAreaInsets.top)
            .horizontally()
            .bottom(view.safeAreaInsets.bottom + view.frame.height / 6)
        
        addButton.pin
            .bottom(view.safeAreaInsets.bottom + 50)
            .height(32)
            .horizontally()
    }
    
    private func disableAddButton() {
        addButton.setTitleColor(.gray, for: .normal)
        addButton.isUserInteractionEnabled = false
    }
    
    private func enableAddButton() {
        addButton.setTitleColor(.link, for: .normal)
        addButton.isUserInteractionEnabled = true
    }
}


extension AddDevicesToGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceToGroupCell") as? DeviceToGroupCell else {
            return .init()
        }
        
        let device = devices[indexPath.row]
        cell.configure(with: device.name, type: device.type)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row].name
        selectedDevices.insert(device)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row].name
        selectedDevices.remove(device)
    }
}
