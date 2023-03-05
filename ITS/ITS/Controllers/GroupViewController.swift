//
//  GroupViewController.swift
//  ITS
//
//  Created by Natalia on 25.12.2022.
//

import UIKit
import PinLayout

class GroupViewController: UIViewController  {
    
    private lazy var presenter = GroupPresenter(output: self)
    
    let addButton: UIButton = UIButton()
    var groupTitle: String
    
    init(title: String) {
        groupTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create objects
    
    private let collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DeviceInGroupCell.self, forCellWithReuseIdentifier: "DeviceInGroupCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 7,
                                                   left: .zero,
                                                   bottom: .zero,
                                                   right: .zero)
        
        return collectionView
        
    }()
    
    private var deviceCellViewObjects: [DeviceCellViewObject] {
        presenter.deviceCellViewObjects
    }
    
    // MARK: - setup
    
    private func setupCollectionView() {
        
        // background of main controller
        collectionView.backgroundColor = .customBackgroundColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
    }
    
    private func setupAddButton() {

        addButton.setImage(UIImage(systemName: Constants.AddButton.iconName), for: .normal)
        addButton.imageView?.tintColor = .customGrey
        addButton.imageView?.layer.transform = CATransform3DMakeScale(2.7, 2.7, 2.7)
        addButton.backgroundColor = Constants.AddButton.backgroundColor
        addButton.layer.cornerRadius = Constants.AddButton.cornerRadius
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.clipsToBounds = true
        
        view.addSubview(addButton)
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        
        title = groupTitle
        
        setupCollectionView()
        setupAddButton()
        presenter.didLoadView(group: groupTitle)
        
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
        
        navigationController?.navigationBar.tintColor = .customGrey
        
    }
    
    // MARK: - Layout
    
    private func layout() {
        
        addButton.pin
            .bottom()
            .marginBottom(view.safeAreaInsets.bottom + Constants.AddButton.marginBottom)
            .height(Constants.AddButton.height)
            .horizontally((view.frame.width - Constants.AddButton.height) / 2)
        
        collectionView.pin
            .top(view.safeAreaInsets.top)
            .horizontally()
            .bottom(view.safeAreaInsets.bottom)
        
    }
    
    func addDeviceCell(with name: String) {
        presenter.addDeviceCell(with: name, group: groupTitle)
    }
    
    func delDeviceCell(name: String) {
        presenter.delDeviceCell(with: name, group: groupTitle)
    }
    
    @objc
    private func didTapAddButton() {
        
        let alertController  = UIAlertController(title: "Add device", message: "Input device`s name", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let okAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alertController.textFields?.first?.text else {
                return
            }
    
            self.addDeviceCell(with: text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GroupViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return deviceCellViewObjects.count
        
    }
    
    // Создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceInGroupCell", for: indexPath) as? DeviceInGroupCell,
            deviceCellViewObjects.count > indexPath.row
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: deviceCellViewObjects[indexPath.row], title: groupTitle)
        
        return cell
    }
    
    // Переход в контроллер ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let deviceViewController = DeviceViewController()
        deviceViewController.title = deviceCellViewObjects[indexPath.row].name

        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(deviceViewController, animated: true)
        self.hidesBottomBarWhenPushed = true

    }
    
}

// MARK: - Cells size

extension GroupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 30, height: 70)
        
    }
}

private extension GroupViewController {
    struct Constants {
        
        struct AddButton {
            static let iconName: String = "plus.circle"
            static let backgroundColor: UIColor = .customBackgroundColor
            static let marginBottom: CGFloat = 0
            static let height: CGFloat = 50
            static let cornerRadius: CGFloat = height / 2
        }
    }
}

extension GroupViewController: GroupPresenterOutput {
    
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

