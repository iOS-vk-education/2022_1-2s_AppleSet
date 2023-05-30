//
//  AirControlViewController.swift
//  ITS
//
//  Created by Всеволод on 15.05.2023.
//

import UIKit
import Lottie


final class AirControlViewController: UIViewController {
    private let deviceName: String
    
    private lazy var presenter = AirControlPresenter(output: self)
    
    private let animationView = LottieAnimationView(name: "dots")
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AirControlFunctionCell.self, forCellWithReuseIdentifier: "AirControlFunctionCell")
        
        return collectionView
    }()
    
    init(name: String) {
        deviceName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter.setup(with: deviceName)
        presenter.didLoadView()
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = deviceName
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animationView.pin
            .width(view.frame.width / 2)
            .height(view.frame.width / 2)
            .hCenter()
            .top(view.safeAreaInsets.top + 100)
        
        collectionView.pin
            .top(view.safeAreaInsets.top + 50)
            .horizontally()
            .bottom()
    }
}

extension AirControlViewController: AirControlPresenterOutput {
    func updateValue(of function: AirController.Function, value: Float) {
        collectionView.performBatchUpdates {
        
            guard
                let index = AirController.Function.allCases.firstIndex(of: function),
                let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? AirControlFunctionCell
            else {
                return
            }
            
            cell.configure(with: function, value: value)
        }
    }
    
    func setConnected() {
        animationView.stop()
        animationView.removeFromSuperview()
        view.addSubview(collectionView)
    }
    
    func setConnecting() {
        view.addSubview(animationView)
        animationView.play()
    }
    
    func setDisconnected() {
        print(#function)
    }
    
    
}

extension AirControlViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AirController.Function.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AirControlFunctionCell", for: indexPath) as? AirControlFunctionCell else {
            return UICollectionViewCell()
        }
        
        cell.isUserInteractionEnabled = false
        
        let function = AirController.Function.allCases[indexPath.row]
        cell.configure(with: function, value: presenter.getValueOfFunction(function: function))
        
        return cell
    }
}

extension AirControlViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 120)
    }
}
