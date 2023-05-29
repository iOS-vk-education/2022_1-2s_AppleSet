//
//  SearchViewController.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import UIKit
import Lottie
import PinLayout

final class SearchViewController: UIViewController {
    private lazy var presenter = SearchPresenter(output: self)
    
    private let animationWiFiView = LottieAnimationView(name: "wifi.json")
    private let animationLoadView = LottieAnimationView(name: "load.json")
    private let animationSuccessView = LottieAnimationView(name: "success.json")
    private let settingsButton = UIButton()
    private let connectButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavBar()
        animationWiFiView.play()
    }
    
    private func setup() {
        title = "Search"
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishSearch), name: DevicesManager.finishNotificationKey, object: nil)
        
        animationWiFiView.contentMode = .scaleAspectFit
        animationWiFiView.loopMode = .loop
        
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.link, for: .normal)
        settingsButton.setTitleColor(.gray, for: .highlighted)
        settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        
        animationLoadView.contentMode = .scaleAspectFit
        animationLoadView.loopMode = .loop
        animationLoadView.isHidden = true
        
        animationSuccessView.contentMode = .scaleAspectFit
        animationSuccessView.loopMode = .playOnce
        animationSuccessView.isHidden = true
        
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitleColor(.systemBlue, for: .normal)
        connectButton.setTitleColor(.gray, for: .highlighted)
        connectButton.addTarget(self, action: #selector(didTapConnectButton), for: .touchUpInside)
        connectButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        view.addSubview(animationWiFiView)
        view.addSubview(settingsButton)
        view.addSubview(connectButton)
        view.addSubview(animationLoadView)
        view.addSubview(animationSuccessView)
    }
    
    private func setupNavBar() {
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBackButton))
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSettingsButton() {
        presenter.didTapSettings()
    }
    
    @objc private func didTapConnectButton() {
        presenter.didTapConnect()
    }
    
    @objc private func finishSearch() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animationWiFiView.pin
            .top(view.safeAreaInsets.top - 40)
            .height(view.frame.width)
            .width(view.frame.width)
            .hCenter()
        
        settingsButton.pin
            .below(of: animationWiFiView)
            .height(32)
            .horizontally()
        
        animationLoadView.pin
            .below(of: settingsButton)
            .marginTop(50)
            .height(view.frame.width / 2)
            .width(view.frame.width / 2)
            .hCenter()
        
        animationSuccessView.pin
            .center(to: animationLoadView.anchor.center)
            .height(view.frame.width / 2)
            .width(view.frame.width / 2)
        
        connectButton.pin
            .bottom(view.safeAreaInsets.bottom + 50)
            .height(32)
            .horizontally()
    }
}

extension SearchViewController: SearchPresenterOutput {
    func disableConnect() {
        connectButton.setTitleColor(.gray, for: .normal)
        connectButton.isUserInteractionEnabled = false
    }
    
    func enableConnect() {
        connectButton.setTitleColor(.systemBlue, for: .normal)
        connectButton.isUserInteractionEnabled = true
    }
    
    func startLoading() {
        animationLoadView.isHidden = false
        animationLoadView.play()
    }
    
    func stopLoading() {
        animationLoadView.isHidden = true
        animationLoadView.stop()
    }
    
    func showSuccess() {
        animationSuccessView.isHidden = false
        animationSuccessView.play { [weak self] _ in
            let configureViewController = ConfigureViewController()
            
            self?.navigationController?.pushViewController(configureViewController, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

