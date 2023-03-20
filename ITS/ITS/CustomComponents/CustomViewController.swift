//
//  CustomViewController.swift
//  ITS
//
//  Created by Natalia on 18.03.2023.
//

import UIKit

class CustomViewController: UIViewController {
    private let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    private let errorView: ErrorView = ErrorView()
    private let impactFeedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupErrorView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicatorView.pin.all()
        
        errorView.pin
            .vCenter()
            .horizontally(32)
            .sizeToFit(.width)
    }
    
    private func setupActivityIndicator() {
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        view.addSubview(activityIndicatorView)
    }
    
    private func setupErrorView() {
        print("? setupErrorView:", self)
        errorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        errorView.isHidden = true
        errorView.alpha = .zero

//        errorView.configure(with: "PinLayout Warning: width(-30.0) won't be applied,")
        
        view.addSubview(errorView)
    }
    
    func showActivity() {
        activityIndicatorView.startAnimating()
    }
    
    func hideActivity() {
        activityIndicatorView.stopAnimating()
    }
    
    func showErrorView(with error: String) {
        
        print("? showErrorView:", self)

//        guard errorView.isHidden else {
//            return
//        }
        
        print(error)
        
        impactFeedbackGenerator.prepare()
        
        errorView.configure(with: error)
        errorView.isHidden = false
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        animateShowErrorView()
    }
    
    private func animateShowErrorView() {
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            self?.errorView.alpha = 1
            
        }) { [weak self] _ in
            self?.impactFeedbackGenerator.impactOccurred()
            self?.animateHideErrorView()
        }
    }
    
    private func animateHideErrorView() {
        UIView.animate(withDuration: 0.6, delay: 3, animations: { [weak self] in
            self?.errorView.alpha = 0
        }) { [weak self] _ in
            self?.errorView.isHidden = true
        }
    }
}
