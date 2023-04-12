//
//  GroupsPresenter.swift
//  ITS
//
//  Created by Natalia on 26.02.2023.
//

protocol GroupsPresenterOutput: AnyObject {
    func reloadData()
    func errorMessage(error: String)
}

class GroupsPresenter {
    private let model: DevicesAndGroupsModel = DevicesAndGroupsModel()
    private weak var output: GroupsPresenterOutput?
    
    var groupCellViewObjects = [GroupCellViewObject]()
    
    init(output: GroupsPresenterOutput) {
        self.output = output
    }
    
    func didLoadView() {
        loadGroups()
    }
}

extension GroupsPresenter {

    // Загружаем данные из БД
    private func loadGroups() {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }
        
        model.loadGroups { result in
            switch result {
            case .success(let groups):
                self.groupCellViewObjects = groups
                output.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addGroupCell(with name: String) {
        
        guard let output = self.output else {
            print("!delegate is nil!")
            return
        }
        
        model.seeAllGroups { result in
            switch result {
            case .success(let groups):
                self.groupCellViewObjects = groups
                
                for group in self.groupCellViewObjects {
                    if group.name == name {
                        output.errorMessage(error: "This group was already add")
                        return
                    }
                }
                
                self.model.addGroup(group: CreateGroupData(name: name, devices: [])) { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
                return
            }
        }
    }

    func delGroupCell(with name: String) {
        
        model.delGroup(group: CreateGroupData(name: name, devices: [])) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}
