//
//  ErrorView.swift
//  ITS
//
//  Created by Natalia on 18.03.2023.
//

import UIKit

class ErrorView: UIView {
    private let containerView: UIView = UIView()
    private let errorLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ERROR: unknown error!")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .white
        
        errorLabel.textColor = .black
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 3
        
        containerView.addSubview(errorLabel)
        addSubview(containerView)
    }
    
    func configure(with text: String) {
        errorLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        performLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: performLayout)
    }
    
    private func performLayout() {
        containerView.pin
            .top()
        
        errorLabel.pin
            .width(max(frame.size.width - 30, .zero))
            .sizeToFit(.widthFlexible)
        
        containerView.pin
            .wrapContent(padding: 15)
            .hCenter()
    }
}
