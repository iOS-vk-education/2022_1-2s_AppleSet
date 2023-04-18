//
//  Color.swift
//  ITS
//
//  Created by New on 05.03.2023.
//

import UIKit

struct Color {
    let lightValue: UIColor
    let darkValue: UIColor
    
    init(lightValue: UIColor, darkValue: UIColor? = nil) {
        self.lightValue = lightValue
        self.darkValue = darkValue ?? lightValue
    }
    
    var value: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return darkValue
            } else {
                return lightValue
            }
        }
    }
}
