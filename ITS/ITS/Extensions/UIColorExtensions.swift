//
//  UIColorExtensions.swift
//  ITS
//
//  Created by Natalia on 27.11.2022.
//

import UIKit

extension UIColor {
    // 6c757d
    static let customLightGrey: UIColor = Color(lightValue: .init(red: 0x6c, green: 0x75, blue: 0x7d, alpha: 1),
                                                darkValue: .init(red: 0x6c, green: 0x75, blue: 0x7d, alpha: 1)).value
    // 03045e
    static let customGrey: UIColor = Color(lightValue: .init(red: 0x03, green: 0x04, blue: 0x5e, alpha: 1),
                                           darkValue: .init(red: 0x03, green: 0x04, blue: 0x5e, alpha: 1)).value
    
    // ebfffa
    static let customBlue: UIColor = Color(lightValue: .init(red: 0xeb, green: 0xff, blue: 0xfa, alpha: 1),
                                            darkValue: .init(red: 0xeb, green: 0xff, blue: 0xfa, alpha: 1)).value
    
    // f28482
    static let customRed: UIColor = Color(lightValue: .init(red: 0xf2, green: 0x84, blue: 0x82, alpha: 1),
                                                darkValue: .init(red: 0xf2, green: 0x84, blue: 0x82, alpha: 1)).value
    //2B709E
    static let customDarkBlue: UIColor = Color(lightValue: .init(red: 0x2b, green: 0x70, blue: 0x9e, alpha: 1),
                                                darkValue: .init(red: 0x2b, green: 0x70, blue: 0x9e, alpha: 1)).value
    
    static let customTextColor: UIColor = Color(lightValue: .init(red: 0, green: 0, blue: 0, alpha: 1),
                                                darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value
    
    static let customBackgroundColor: UIColor = Color(lightValue: UIColor(white: 1, alpha: 1),
                                                      darkValue: UIColor(white: 0.1, alpha: 1)).value
    
    static let customBackgroundFieldColor: UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1),
                                                           darkValue: .init(red: 0, green: 0, blue: 0, alpha: 1)).value
    
    
    
}
