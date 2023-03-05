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
    
    private lazy var presenter = GroupsPresenter(output: self)

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
    
    private var groupCellViewObjects: [GroupCellViewObject] {
        presenter.groupCellViewObjects
    }
    
    // MARK: - setup
    
    private func setupCollectionView() {

        collectionView.backgroundColor = .customBackgroundColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .customBackgroundColor
    
        setupCollectionView()
        presenter.didLoadView()

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
    
    // MARK: - add device cell
    
    func addGroupCell(with name: String) {
        
        presenter.addGroupCell(with: name)
    }
    
    func delGroupCell(name: String) {
        
        presenter.delGroupCell(with: name)
        
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
        return groupCellViewObjects.count
    }
    
    // Создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell,
            groupCellViewObjects.count > indexPath.row
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: groupCellViewObjects[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let groupViewController = GroupViewController(title: groupCellViewObjects[indexPath.row].name)
        groupViewController.title = groupCellViewObjects[indexPath.row].name

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

extension GroupsViewController: GroupsPresenterOutput {
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func errorMessage(error: String) {
        let errorAlertController  = UIAlertController(title: "Error", message: error, preferredStyle: .alert)

        let errorOkAction = UIAlertAction(title: "Ok", style: .default)
        errorAlertController.addAction(errorOkAction)
        present(errorAlertController, animated: true)
        print(error)

    }
}
