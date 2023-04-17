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
    
    static let customBlue: UIColor = Color(lightValue: .init(red: 228, green: 229, blue: 234)
                                           ,darkValue: .init(red: 0x03, green: 0x42, blue: 0x75)).value
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
    
    static let tapBarbutton: UIColor = Color(lightValue: .init(red: 0, green: 0, blue: 0, alpha: 1)
                                            ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value
    
    static let tapBarBackground: UIColor = Color(lightValue: UIColor(red: 217, green: 217, blue: 217),
                                       darkValue: UIColor(red: 0, green: 0, blue: 0)).value

    static let navigationBarBackground: UIColor = Color(lightValue: UIColor(red: 50, green: 51, blue: 52, alpha: 100),
                                                      darkValue: UIColor(red: 0, green: 0, blue: 0)).value
    
    static let TextOnnavigationBar: UIColor = Color(lightValue: UIColor(red: 255, green: 255, blue: 255),
                                                    darkValue: UIColor(red: 255, green: 255, blue: 255)).value
    
    
    static let customBackgroundColor: UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                ,darkValue: .init(red: 0, green: 0, blue: 0, alpha: 1)).value
    
    static let arrowAndIconsBackOnNavbar: UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value
    
    static let customBackgroundDeviceColor: UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                            ,darkValue: .init(white: 0.1, alpha: 1)).value
    
    
    static let customTextColor: UIColor = Color(lightValue: .init(red: 0, green: 0, blue: 0, alpha: 1)
                                                ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value
    
    static let AddDeviceTextColorBlueButton: UIColor = Color(lightValue: .init(red: 0x2b, green: 0x70, blue: 0x9a)
                                                             ,darkValue: .init(red: 0x3d, green: 0x83, blue: 0xc9)).value
//    static let customTextColorDevice: UIColor = Color(lightValue: .init(red: 0x03, green: 0x42, blue: 0x75)
//                                                ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value
    
    static let customGrey: UIColor = Color(lightValue: .darkGray
                                           ,darkValue: .init(red: 255, green: 255, blue: 255, alpha: 1)).value

    
    static let customBackgroundLayer:  UIColor = Color(lightValue: .init(red: 255, green: 255, blue: 255, alpha: 1)
                                                       ,darkValue: .init(white: 0.3, alpha: 1)).value
    
    static let customButtonShadowColor: UIColor = Color(lightValue: .systemGray,
                                                        darkValue: .init(white: 0.3, alpha: 1)).value
                        
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
            var fRed : CGFloat = 0
            var fGreen : CGFloat = 0
            var fBlue : CGFloat = 0
            var fAlpha: CGFloat = 0
            if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                let iRed = Int(fRed * 255.0)
                let iGreen = Int(fGreen * 255.0)
                let iBlue = Int(fBlue * 255.0)
                let iAlpha = Int(fAlpha * 255.0)

                return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
            } else {
                // Could not extract RGBA components:
                return nil
            }
        }
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
