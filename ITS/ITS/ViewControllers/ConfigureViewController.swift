//
//  ConfigureViewController.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import UIKit
import PinLayout
import Lottie



final class ConfigureViewController: UIViewController {
    private lazy var presenter = ConfigurePresenter(output: self)
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let networkTextField = UITextField()
    private let passwordTextField = UITextField()
    private let setupButton = UIButton()
    
    private var networks = [Network]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavBar()
        presenter.didLoadView()
    }
    
    private func setup() {
        title = "Configure"
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(finishConfigure), name: DevicesManager.finishNotificationKey, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NetworkCell.self, forCellReuseIdentifier: "NetworkCell")
        tableView.refreshControl = refreshControl
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        networkTextField.placeholder = "Wi-Fi"
        networkTextField.backgroundColor = .systemGray6
        networkTextField.layer.borderWidth = 1
        networkTextField.layer.borderColor = UIColor.systemGray5.cgColor
        networkTextField.layer.cornerRadius = 10
        networkTextField.isUserInteractionEnabled = false
        
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGray5.cgColor
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.addTarget(self, action: #selector(didPasswordChanged), for: .editingChanged)
        passwordTextField.isUserInteractionEnabled = false
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        
        setupButton.setTitle("Setup", for: .normal)
        setupButton.setTitleColor(.gray, for: .highlighted)
        setupButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        setupButton.addTarget(self, action: #selector(didTapSetupButton), for: .touchUpInside)
        disableSetupButton()
        
        
        view.addSubview(tableView)
        view.addSubview(networkTextField)
        view.addSubview(passwordTextField)
        view.addSubview(setupButton)
    }
    
    private func setupNavBar() {
        let reloadButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didPullToRefresh))
        
        navigationItem.rightBarButtonItem = reloadButtonItem
        navigationController?.navigationBar.tintColor = .link
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.pin
            .top(view.safeAreaInsets.top)
            .horizontally()
            .height(view.frame.height / 2)
        
        networkTextField.pin
            .below(of: tableView)
            .marginTop(50)
            .height(40)
            .horizontally(32)
        
        passwordTextField.pin
            .below(of: networkTextField)
            .marginTop(20)
            .height(40)
            .horizontally(32)
        
        setupButton.pin
            .below(of: passwordTextField)
            .marginTop(30)
            .height(32)
            .horizontally()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func didPullToRefresh() {
        presenter.didUpdateNetworks()
    }
    
    @objc private func didPasswordChanged() {
        guard
            let network = networkTextField.text,
            !network.isEmpty,
            let password = passwordTextField.text,
            password.count >= 8
        else {
            disableSetupButton()
            return
        }
        
        enableSetupButton()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        tableView.isHidden = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 1.5
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.isHidden = false
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func didTapSetupButton() {
        guard
            let network = networkTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        
        presenter.didSetupNetwork(name: network, password: password)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func finishConfigure() {
        navigationController?.popViewController(animated: true)
    }
    
    private func disableSetupButton() {
        setupButton.setTitleColor(.gray, for: .normal)
        setupButton.isUserInteractionEnabled = false
    }
    
    private func enableSetupButton() {
        setupButton.setTitleColor(.link, for: .normal)
        setupButton.isUserInteractionEnabled = true
    }
    
    private func disableReloadButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func enableReloadButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension ConfigureViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkCell") as? NetworkCell else {
            return .init()
        }
        
        let network = networks[indexPath.row]
        cell.configure(with: network.ssid, isOpen: network.isOpen)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let network = networks[indexPath.row]
        
        networkTextField.text = network.ssid
        passwordTextField.isUserInteractionEnabled = true
    }
}


extension ConfigureViewController: ConfigurePresenterOutput {
    func goToCreate() {
        let createViewController = CreateViewController()
        
        navigationController?.pushViewController(createViewController, animated: true)
    }
    
    func disableReload() {
        disableReloadButton()
    }
    
    func enableReload() {
        enableReloadButton()
    }
    
    func startLoading() {
        refreshControl.beginRefreshing()
    }
    
    func stopLoading() {
        refreshControl.endRefreshing()
    }
    
    func disableSetup() {
        disableSetupButton()
    }
    
    func enableSetup() {
        enableSetupButton()
    }
    
    func updateNetworks(networks: [Network]) {
        self.networks = networks
        tableView.reloadData()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

