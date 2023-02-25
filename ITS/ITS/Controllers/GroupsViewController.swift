//
//  GroupsViewController.swift
//  ITS
//
//  Created by Natalia on 26.11.2022.
//

import UIKit
import PinLayout

class GroupsViewController: UIViewController {
    
    // MARK: - Create objects

    private let collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: "GroupCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 7,
                                                   left: .zero,
                                                   bottom: .zero,
                                                   right: .zero)

        return collectionView
    }()
    
    private var models: [GroupCellViewObject] = []
    let databaseManager = DatabaseManager.shared
    lazy var user: String = databaseManager.getCurrentUser()
    
    // MARK: - setup
    
    private func setupCollectionView() {

        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    
        setupCollectionView()
        loadGroups()

    }
    
    // MARK: - WiewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
        
    }
    
    // MARK: - viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
        
    }
    
//    // MARK: - Load places
//
//    // Загружаем данные из БД
//    private func loadGroups() {
//
//        let groupModel = GroupCellDataModel()
//        models = groupModel.loadGroups()
//    }
    
    // MARK: - set up navigation bar
    
    private func setupNavBar() {
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark"),
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(didTapQuestionButton))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .customGrey
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapProfileButton))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .customGrey
    }
    
    // MARK: - Layout
    
    private func layout() {
        
        collectionView.pin
            .top(view.safeAreaInsets.top)
            .horizontally()
            .bottom(view.safeAreaInsets.bottom)
    }
    
    // Загружаем данные из БД
    private func loadGroups() {
        
        databaseManager.loadGroups(user: self.user) { result in
            switch result {
            case .success(let groups):
                self.models = groups
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - add device cell
    
    func addGroupCell(with name: String) {
        
        databaseManager.seeAllGroups(user: self.user) { result in
            switch result {
            case .success(let groups):
                self.models = groups
                
                for group in self.models {
                    if group.name == name {
                        self.errorMessage(error: "This group was already add")
                        return
                    }
                }
                
                self.databaseManager.addGroup(user: self.user, group: CreateGroupData(name: name, devices: [])) { result in
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
    
    func delGroupCell(name: String) {
        
        databaseManager.delGroup(user: self.user, group: CreateGroupData(name: name, devices: [])) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    func errorMessage(error: String)
    {
        let errorAlertController  = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let errorOkAction = UIAlertAction(title: "Ok", style: .default)
        errorAlertController .addAction(errorOkAction)
        present(errorAlertController, animated: true)
        print(error)
    }
    
    // MARK: - Question button action
    
    @objc
    private func didTapQuestionButton() {
        
        let alertController: UIAlertController = UIAlertController(title: "Инструкция",
                                                 message: "Для добавления группы, нажмите кнопку + внизу экрана. Далее укажите название группы",
                                                 preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "Ок", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Profile button action
    
    @objc
    private func didTapProfileButton() {
        let profileController = ProfileViewController()
        
        let navigationController = UINavigationController(rootViewController: profileController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    // Создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell,
            models.count > indexPath.row
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let groupViewController = GroupViewController(title: models[indexPath.row].name)
        groupViewController.title = models[indexPath.row].name

        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(groupViewController, animated: true)
        self.hidesBottomBarWhenPushed = false

    }
}

// MARK: - Cells size

extension GroupsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 30, height: 70)
    }
}
