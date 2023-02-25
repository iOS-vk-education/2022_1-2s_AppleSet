//
//  DeviceInGroupCell.swift
//  ITS
//
//  Created by Natalia on 25.12.2022.
//

import UIKit
import PinLayout

final class DeviceInGroupCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    var nameLabel: UILabel!
    var pan: UIPanGestureRecognizer!
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    var groupTitle: String?
    
    private var viewObject: DeviceCellViewObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        
        setup()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setup() {
        contentView.backgroundColor = .customBlue
        backgroundColor = .customRed
        layer.cornerRadius = Constants.DeviceInGroupCell.cornerRadius
        clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .customGrey
        nameLabel.font = Constants.DeviceInGroupCell.nameLabelFont
        addSubview(nameLabel)

        deleteLabel1 = UILabel()
        deleteLabel1.text = "delete"
        deleteLabel1.textColor = UIColor.white
        self.insertSubview(deleteLabel1, belowSubview: self.contentView)

        deleteLabel2 = UILabel()
        deleteLabel2.text = "delete"
        deleteLabel2.textColor = UIColor.white
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)

        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.pin
            .centerLeft(13)
            .right(13)
            .sizeToFit(.width)
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            self.deleteLabel1.frame = CGRect(x: p.x - deleteLabel1.frame.size.width, y: 37, width: 77, height: height - 37)
            self.deleteLabel2.frame = CGRect(x: p.x + width + deleteLabel2.frame.size.width, y: 37, width: 77, height: height - 37)
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                
                GroupViewController(title: groupTitle ?? "").delDeviceCell(name: nameLabel.text!)
                
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
    // NOT ADD
    
    func configure(with viewObject: DeviceCellViewObject, title: String?) {
        self.viewObject = viewObject
        nameLabel.text = viewObject.name
        nameLabel.textColor = .black
        groupTitle = title
    }
}

// MARK: - Static values

private extension DeviceInGroupCell {
    struct Constants {
        
        struct DeviceInGroupCell {
            static let cornerRadius: CGFloat = 13
            static let nameLabelFont: UIFont = UIFont(name: "Menlo-Bold", size: 17)!
        }
    }
}
