//
//  AirControlFunctionCell.swift
//  ITS
//
//  Created by Всеволод on 15.05.2023.
//

import UIKit
import PinLayout


final class AirControlFunctionCell: UICollectionViewCell {
    
    private let functionLabel: UILabel = UILabel()
    private let valueLabel: UILabel = UILabel()
    private let iconView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.systemGray5.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        layer.shadowOffset = CGSize(width: 5.0, height: 10.0)
        
        functionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        functionLabel.textColor = .customGrey
        functionLabel.textAlignment = .left
        
        valueLabel.font = UIFont.boldSystemFont(ofSize: 30)
        valueLabel.textColor = .customGrey
        valueLabel.textAlignment = .right
        
        iconView.isUserInteractionEnabled = false
        iconView.contentMode = .scaleAspectFit
        
        addSubview(functionLabel)
        addSubview(valueLabel)
        addSubview(iconView)
    }
    
    func configure(with function: AirController.Function, value: Float) {
        functionLabel.text = function.rawValue.uppercased()
        
        switch function {
        case .temperature:
            iconView.image = UIImage(systemName: "thermometer.sun")
            valueLabel.text = String(value) + " \u{B0}C"
        case .humidity:
            iconView.image = UIImage(systemName: "humidity")
            valueLabel.text = String(value) + " %"
        case .pressure:
            iconView.image = UIImage(systemName: "tornado")
            valueLabel.text = String(value) + " hPa"
        case .height:
            iconView.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
            valueLabel.text = String(value) + " m"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        functionLabel.pin
            .topLeft(18)
            .right(contentView.frame.width / 2)
            .sizeToFit(.width)
        
        valueLabel.pin
            .top(contentView.frame.height / 2)
            .horizontally(18)
            .sizeToFit(.width)
        
        iconView.pin
            .bottomLeft(10)
            .size(CGSize(width: 50, height: 50))
    }
}
