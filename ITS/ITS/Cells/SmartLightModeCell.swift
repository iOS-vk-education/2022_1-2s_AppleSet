//
//  SmartLightModeCell.swift
//  ITS
//
//  Created by Всеволод on 29.04.2023.
//

import UIKit
import PinLayout


final class SmartLightModeCell: UICollectionViewCell {
    
    private let name: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        name.font = UIFont(name: "Marker Felt", size: 20)
        name.textAlignment = .center
        layer.cornerRadius = frame.height / 2
        addSubview(name)
    }
    
    func configure(with name: String, isSelected: Bool) {
        self.name.text = name
        
        if isSelected {
            backgroundColor = .customGrey
            self.name.textColor = .white
        } else {
            backgroundColor = .customBlue
            self.name.textColor = .customGrey
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        name.pin.all()
    }
}
