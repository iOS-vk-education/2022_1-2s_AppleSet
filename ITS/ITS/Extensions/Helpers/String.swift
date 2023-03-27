//
//  String.swift
//  ITS
//
//  Created by Всеволод on 27.03.2023.
//

import Foundation


extension String {
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits

        return CharacterSet(charactersIn: self).isSubset(of: characters)
    }
}
