//
//  PlaceViewController.swift
//  ITS
//
//  Created by Natalia on 20.11.2022.
//

import UIKit
import PinLayout

final class DeviceViewController: UIViewController {
    
    let addFunctionButton: UIButton = UIButton()

    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FunctionCell.self, forCellWithReuseIdentifier: "FunctionCell")
       
        collectionView.contentInset = UIEdgeInsets(top: 7,
                                                   left: .zero,
                                                   bottom: .zero,
                                                   right: .zero)
        
        return collectionView
    }()
    
    private var models: [FunctionCellViewObject] = []
    let databaseManager = DatabaseManager.shared
    lazy var user: String = databaseManager.getCurrentUser()

    private func setup()
    {
        view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func setupAddFunctionButton() {

        addFunctionButton.setImage(UIImage(systemName: Constants.AddFunctionButton.iconName), for: .normal)
        addFunctionButton.imageView?.tintColor = .white
        addFunctionButton.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        addFunctionButton.backgroundColor = Constants.AddFunctionButton.backgroundColor
        addFunctionButton.layer.cornerRadius = Constants.AddFunctionButton.cornerRadius
        addFunctionButton.addTarget(self, action: #selector(didTapAddFunctionButton), for: .touchUpInside)
        addFunctionButton.clipsToBounds = true
        
        view.addSubview(addFunctionButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddFunctionButton()
        setup()
        loadDevice()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addFunctionButton.pin
            .bottom()
            .marginBottom(view.safeAreaInsets.bottom + Constants.AddFunctionButton.marginBottom)
            .height(Constants.AddFunctionButton.height)
            .horizontally((view.frame.width - Constants.AddFunctionButton.height) / 2)
        
        collectionView.pin
            .top(view.safeAreaInsets.top + 7)
            .horizontally()
            .bottom(view.safeAreaInsets.bottom + addFunctionButton.frame.height + Constants.AddFunctionButton.marginBottom * 2)
        
    }
    
    private func loadDevice() {
        let functionModel = FunctionCellDataModel()
        models = functionModel.loadFunctions()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    // MARK: - Setup
    
    private func setupNavBar() {
        
        navigationController?.navigationBar.tintColor = .customGrey
        
    }
    
    // MARK: - add place cell
    
    private func addFunctionCell(with name: String) {
        
        let model = FunctionCellViewObject(name: name)
        self.models.append(model)
    
        self.collectionView.insertItems(at: [IndexPath(row: self.models.count - 1, section: 0)])
    }
    
    // MARK: - Actions

    @objc
    private func didTapAddFunctionButton() {
        
        let alertController  = UIAlertController(title: "Add function", message: "Input function`s name", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let okAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alertController.textFields?.first?.text else {
                return
            }
    
            self.addFunctionCell(with: text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
}

extension DeviceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FunctionCell",
                                                          for: indexPath) as? FunctionCell,
                models.count > indexPath.row
            else {
                return UICollectionViewCell()
        }
        
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
}

extension DeviceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 30, height: 100)
    }
}

private extension DeviceViewController {
    struct Constants {
        
        struct AddFunctionButton {
            static let iconName: String = "plus"
            static let backgroundColor: UIColor = .customBlue
            static let marginBottom: CGFloat = 10
            static let height: CGFloat = 65
            static let cornerRadius: CGFloat = height / 2
        }
    }
}

