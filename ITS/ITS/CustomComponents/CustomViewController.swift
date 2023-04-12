//
//  CustomViewController.swift
//  ITS
//
//  Created by Natalia on 18.03.2023.
//

import UIKit

class CustomViewController: UIViewController {
    private let errorView: ErrorView = ErrorView()
    private let impactFeedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorView()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        errorView.pin
//            .vCenter()
//            .horizontally(32)
//            .sizeToFit(.width)
//    }
    
    private func setupErrorView() {
        
        
        view.addSubview(errorView)
        errorView.backgroundColor = UIColor.red
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint(item: errorView,
//                           attribute: NSLayoutConstraint.Attribute.centerX,
//                           relatedBy: NSLayoutConstraint.Relation.equal,
//                           toItem: view,
//                           attribute: NSLayoutConstraint.Attribute.centerX,
//                           multiplier: 1,
//                           constant: 0).isActive = true
//
//        NSLayoutConstraint(item: errorView,
//                           attribute: NSLayoutConstraint.Attribute.centerY,
//                           relatedBy: NSLayoutConstraint.Relation.equal,
//                           toItem: view,
//                           attribute: NSLayoutConstraint.Attribute.centerY,
//                           multiplier: 1,
//                           constant: 0).isActive = true
//
//        NSLayoutConstraint(item: errorView,
//                           attribute: NSLayoutConstraint.Attribute.width,
//                           relatedBy: NSLayoutConstraint.Relation.equal,
//                           toItem: nil,
//                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
//                           multiplier: 1,
//                           constant: 100).isActive = true
//
//        NSLayoutConstraint(item: errorView,
//                           attribute: NSLayoutConstraint.Attribute.height,
//                           relatedBy: NSLayoutConstraint.Relation.equal,
//                           toItem: nil,
//                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
//                           multiplier: 1,
//                           constant: 100).isActive = true
        
        errorView.pin
            .vCenter()
            .horizontally(32)
            .sizeToFit(.width)
        
        print("? setupErrorView:", self)
        errorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        errorView.isHidden = true
        errorView.alpha = .zero

    }
    
    
    func showErrorView(with error: String) {
        
        print("? showErrorView:", self)

//        guard errorView.isHidden else {
//            print("?!?")
//            return
//        }
        
        print("!error: \(error)")
        
        impactFeedbackGenerator.prepare()
        
        errorView.configure(with: error)
        errorView.backgroundColor = UIColor.red
        errorView.alpha = 1
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
