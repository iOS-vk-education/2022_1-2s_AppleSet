//
//  DeviceToGroupCell.swift
//  ITS
//
//  Created by Всеволод on 29.05.2023.
//

import UIKit
import PinLayout


final class DeviceToGroupCell: UITableViewCell {
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
    
    func configure(with name: String, type: CreateDeviceData.DeviceType) {
        nameLabel.text = name
        iconView.image = (type == .SmartLight) ? UIImage(systemName: "lightbulb.led") : UIImage(systemName: "air.purifier")
        iconView.tintColor = .black
    }
}
