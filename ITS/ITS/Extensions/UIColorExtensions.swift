//
//  UIColorExtensions.swift
//  ITS
//
//  Created by Natalia on 27.11.2022.
//

import UIKit

extension UIColor {
    // 6c757d
    //цвет для переходного значки девайсы-группы
    static let customLightGrey: UIColor = .lightGray
    
//    static let customLightGrey = UIColor(red: 0x6c / 255,
//                                    green: 0x75 / 255,
//                                    blue: 0x7d / 255,
//                                    alpha: 1)
    
    // 03045e
    
//    static let customGrey = UIColor(red: 0x32 / 255,
//                                    green: 0x33 / 255,
//                                    blue: 0x34 / 255,
//                                    alpha: 1)
    
//
//    static let customBlue: UIColor = Color(lightValue: .init(red: 0xd6, green: 0xe6, blue: 0xf2, alpha: 1)
//                                           ,darkValue: .init(red: 0xAC, green: 0xC7, blue: 0xE1, alpha: 1)).value
    
    static let customBlue = UIColor(red: 0xac / 255,
                                    green: 0xc7 / 255,
                                    blue: 0xe1 / 255,
                                    alpha: 1)
    
    // f28482
    static let customRed = UIColor(red: 0xf2 / 255,
                                   green: 0x84 / 255,
                                   blue: 0x82 / 255,
                                   alpha: 1)
    //2B709E
    static let customDarkBlue = UIColor(red: 0x2b / 255,
                                        green: 0x70 / 255,
                                        blue: 0x9e / 255,
                                        alpha: 1)
    
    
    static let customBackgroundColor: UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                ,darkValue: .init(red: 0, green: 0, blue: 0, alpha: 1)).value
    
    static let customBackgroundDeviceColor: UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                            ,darkValue: .init(white: 0.1, alpha: 1)).value
    
    
    static let customTextColor: UIColor = Color(lightValue: .init(red: 0, green: 0, blue: 0, alpha: 1)
                                                ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value
    
    static let customGrey: UIColor = Color(lightValue: .darkGray
                                           ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value

    
    static let customBackgroundLayer:  UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                       ,darkValue: .init(white: 0.3, alpha: 1)).value
    
    static let customButtonShadowColor: UIColor = Color(lightValue: .systemGray,
                                                        darkValue: .init(white: 0.3, alpha: 1)).value
//    static let customBackgroundColor = UIColor(red: 255 / 255,
//                                               green: 255 / 255,
//                                               blue: 255 / 255,
//                                               alpha: 1)
//
//    static let customTextColor = UIColor(red: 0 / 255,
//                                           green: 0 / 255,
//                                           blue: 0 / 255,
//                                           alpha: 1)
}
