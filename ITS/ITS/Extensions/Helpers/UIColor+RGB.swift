//
//  UIColor+RGB.swift
//  ITS
//
//  Created by New on 05.03.2023.
//

import UIKit

extension UIColor {
    convenience init(red: Int, geen: Int, blue: Int, alpha: CGFloat = 1){
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(geen) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
