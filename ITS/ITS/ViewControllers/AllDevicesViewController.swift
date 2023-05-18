//
//  ViewController.swift
//  ITS
//
//  Created by Всеволод on 02.11.2022.
//

import UIKit
import PinLayout

class AllDevicesViewController: CustomViewController {
    
    private lazy var presenter = AllDevicesPresenter(output: self)
    
    // MARK: - Create objects
    
    private let collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DeviceCell.self, forCellWithReuseIdentifier: "DeviceCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 7,
                                                   left: .zero,
                                                   bottom: .zero,
                                                   right: .zero)
        
        return collectionView
        
    }()
    
//    let Gif = UIImage.gifImageWithName("backgoundGif")
    
//    let imageGif = UIImageView(image: UIImage.gifImageWithName("tulenLight"))
    var imageGif = UIImageView(image: UIImage.gifImageWithName("tulenLight"))
    
    private var deviceCellViewObjects: [DeviceCellViewObject] {
        presenter.deviceCellViewObjects
    }
    
    // MARK: - setup
    
    private func setupCollectionView() {
        
       
        // background of main controller
        collectionView.backgroundColor = .customBackgroundDeviceColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
       
        imageGif.frame = CGRect(x: 1.0, y: 260.0, width: self.view.frame.size.width - 40, height: 400.0) //Giiiiffff

      
            print("setupCollectionView \(deviceCellViewObjects.count)")
            
            
            if deviceCellViewObjects.count == 0{
                view.addSubview(collectionView)
                view.addSubview(imageGif)
            } else {
                view.addSubview(collectionView)
            }
            
   
//
    
        
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation bar
        view.backgroundColor = .customBackgroundColor
        if traitCollection.userInterfaceStyle == .light
        {
            imageGif = UIImageView(image: UIImage.gifImageWithName("tulenLight"))
        } else {
            imageGif = UIImageView(image: UIImage.gifImageWithName("tulenDarck"))
        }
            presenter.didLoadView()
            setupCollectionView()
  
       
        
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
        navigationItem.rightBarButtonItem?.tintColor = .arrowAndIconsBackOnNavbar // sing ?
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapProfileButton))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .arrowAndIconsBackOnNavbar  // avatar
        
    }
    
    // MARK: - Layout
    
    private func layout() {
        
        collectionView.pin
            .top(view.safeAreaInsets.top)
            .horizontally()
            .bottom(view.safeAreaInsets.bottom)
        
    }
    
    // MARK: - add device cell

    func addDeviceCell(with data: CreateDeviceData) {
    
            presenter.addDeviceCell(with: data)
    }

    func delDeviceCell(name: String) {
        
            presenter.delDeviceCell(with: name)
    }
    
    // MARK: - Question button action
    
    @objc
    private func didTapQuestionButton() {
        
        let alertController: UIAlertController = UIAlertController(title: "Инструкция",
                                                                   message: "Для добавления устройства, нажмите кнопку + внизу экрана. Далее укажите название устройства.",
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

extension AllDevicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        if deviceCellViewObjects.count == 1{
            print("\(deviceCellViewObjects.count)")
        }
        return deviceCellViewObjects.count
        
    }
    
    // Создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCell", for: indexPath) as? DeviceCell,
            deviceCellViewObjects.count > indexPath.row
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: deviceCellViewObjects[indexPath.row])
        
        return cell
    }
    
    // Переход в контроллер ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let name = deviceCellViewObjects[indexPath.row].name
        let type = DevicesManager.shared.getTypeByName(name: name)
        
        switch type {
        case .SmartLight:
            let deviceViewController = SmartLightViewController(name: name)
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(deviceViewController, animated: true)
            self.hidesBottomBarWhenPushed = false
        case .AirControl:
            let deviceViewController = AirControlViewController(name: name)
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(deviceViewController, animated: true)
            self.hidesBottomBarWhenPushed = false
        default:
            let deviceViewController = DeviceViewController()
            deviceViewController.title = name
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(deviceViewController, animated: true)
            self.hidesBottomBarWhenPushed = false
        }

        

    }
    
}

// MARK: - Cells size

extension AllDevicesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 30, height: 70)
        
    }
}

extension AllDevicesViewController: AllDevicesPresenterOutput {
    
    func reloadData() {
        if deviceCellViewObjects.count > 0 {
            imageGif.isHidden = true
        } else {
            imageGif.isHidden = false 
        }
        
        collectionView.reloadData()
    }
    
    func errorMessage(error: String) {
        
        showErrorView(with: error)
        
//        let errorAlertController  = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
//
//        let errorOkAction = UIAlertAction(title: "Ok", style: .default)
//        errorAlertController.addAction(errorOkAction)
//        present(errorAlertController, animated: true)
//        print(error)
    }
}
