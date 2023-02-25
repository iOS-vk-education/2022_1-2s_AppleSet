//
//  DeviceCellDataModel.swift
//  ITS
//
//  Created by Natalia on 20.11.2022.
//

// Заглушка, пока не подключили сервак
import UIKit

struct FunctionCellDataModel {
    func loadFunctions() -> [FunctionCellViewObject] {
        let functions: [FunctionCellViewObject] = [
            .init(name: "Температура",
                  values: "22"),
            .init(name: "Влажность",
                  values: "22"),
            .init(name: "Свет",
                  values: "Выключен"),
            .init(name: "Давление",
                  values: "753 мм рт.ст."),
            .init(name: "Шум",
                  values: "50 Дб")]
        
        return functions
    }
}
