//
//  NetworkCell.swift
//  ITS
//
//  Created by Всеволод on 28.05.2023.
//

import UIKit
import PinLayout


final class NetworkCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let iconView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        iconView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.pin
            .left(12)
            .height(24)
            .width(contentView.frame.width - 100)
            .vCenter()
        
        iconView.pin
            .right(12)
            .size(24)
            .vCenter()
    }
    
    func configure(with name: String, isOpen: Bool) {
        nameLabel.text = name
        iconView.image = isOpen ? nil : UIImage(systemName: "lock.fill")
        iconView.tintColor = .black
    }
}

