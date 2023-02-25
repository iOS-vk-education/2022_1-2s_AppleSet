//
//  DeviceCell.swift
//  ITS
//
//  Created by Natalia on 20.11.2022.
//

import UIKit
import PinLayout


final class FunctionCell: UICollectionViewCell {

    private let nameLabel: UILabel = UILabel()
    private let values: UILabel = UILabel()
//    private let imageView: UIImageView = UIImageView()
    
    private var viewObject: FunctionCellViewObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setup() {
        backgroundColor = .customBlue
        layer.cornerRadius = Constants.FunctionCell.cornerRadius
        clipsToBounds = true
        
        nameLabel.font = UIFont(name: "Menlo-Bold", size: 18)
        values.font = UIFont(name: "Menlo-Bold", size: 16)
        
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        
        addSubview(nameLabel)
        addSubview(values)
//        addSubview(imageView)
    }
    
    func configure(with viewObject: FunctionCellViewObject) {
        self.viewObject = viewObject
        
        nameLabel.text = viewObject.name
//        imageView.image = model.image
        values.text = viewObject.values
        nameLabel.textColor = UIColor(red:  0x32 / 255,
                                      green:  0x33 / 255,
                                      blue:  0x34 / 255,
                                      alpha: 1)
        values.textColor = UIColor(red:  0x32 / 255,
                                   green:  0x33 / 255,
                                   blue:  0x34 / 255,
                                   alpha: 1)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        nameLabel.pin
            .topLeft(18)
            .right(18)
            .sizeToFit(.width)

        values.pin
            .below(of: nameLabel)
            .bottomLeft(18)
            .right(18)
            .marginTop(16)
            .sizeToFit(.width)
        
//        imageView.pin
//            .below(of: values)
//            .center()
//            .marginTop(16)
//            .above(of: values)
//            .marginBottom(10)
//            .horizontally()
    }
}

// MARK: - Static values

private extension FunctionCell {
    struct Constants {
        
        struct FunctionCell {
            static let cornerRadius: CGFloat = 13
            static let nameLabelFont: UIFont = UIFont(name: "Menlo-Bold", size: 17)!
        }
    }
}
