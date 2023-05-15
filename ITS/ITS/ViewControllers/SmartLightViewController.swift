//
//  LampViewController.swift
//  ITS
//
//  Created by Всеволод on 09.04.2023.
//

import UIKit
import PinLayout
import ColorSlider
import Lottie



final class SmartLightViewController: UIViewController {
    private var deviceName: String
    
    private lazy var presenter = SmartLightPresenter(output: self)
    
    private let animationView = LottieAnimationView(name: "dots")
    
    private var mode: SmartLight.Mode? = nil
    private let modesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SmartLightModeCell.self, forCellWithReuseIdentifier: "SmartLightModeCell")
        collectionView.contentInset = UIEdgeInsets(top: .zero,
                                                   left: 14,
                                                   bottom: .zero,
                                                   right: 14)
        return collectionView
    }()

    private let button = UIButton()
    private let brightSlider = UISlider()
    let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
    
    
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
        
        modesCollectionView.delegate = self
        modesCollectionView.dataSource = self
        modesCollectionView.showsHorizontalScrollIndicator = false
        
        colorSlider.addTarget(self, action: #selector(didColorSliderValueChanged), for: .touchUpInside)
        
        brightSlider.minimumValue = 0
        brightSlider.maximumValue = 255
        brightSlider.addTarget(self, action: #selector(didBrightSliderValueChanged), for: .touchUpInside)
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animationView.pin
            .width(view.frame.width / 2)
            .height(view.frame.width / 2)
            .hCenter()
            .top(view.safeAreaInsets.top + 100)
        
        modesCollectionView.pin
            .top(view.safeAreaInsets.top + 16)
            .horizontally()
            .height(50)
        
        button.pin
            .bottom(50)
            .height(32)
            .horizontally(32)
        
        colorSlider.pin
            .above(of: button)
            .marginBottom(50)
            .horizontally(32)
            .height(32)
        
        brightSlider.pin
            .above(of: button)
            .marginBottom(50)
            .horizontally(32)
    }
    
    @objc func didTapButton() {
        presenter.didStateChanged()
    }
    
    @objc func didBrightSliderValueChanged() {
        presenter.didBrightnessChanged(brightness: brightSlider.value)
    }
    
    @objc func didColorSliderValueChanged() {
        presenter.didColorChanged(color: colorSlider.color)
    }
}

extension SmartLightViewController: SmartLightPresenterOutput {
    
    func setupMode(mode: SmartLight.Mode) {
        self.mode = mode
        switch mode {
        case .light:
            colorSlider.removeFromSuperview()
            view.addSubview(brightSlider)
        case .multicolor:
            brightSlider.removeFromSuperview()
            view.addSubview(colorSlider)
        }
    }
    
    func setupState(state: SmartLight.State) {
        switch state {
        case .off:
            button.setTitle("ON", for: .normal)
            button.setTitleColor(.systemBlue.withAlphaComponent(0.8), for: .normal)
            button.isUserInteractionEnabled = true
        case .on:
            button.setTitle("OFF", for: .normal)
            button.setTitleColor(.systemRed.withAlphaComponent(0.8), for: .normal)
            button.isUserInteractionEnabled = true
        case .disconnected:
            button.setTitle("CHECKING...", for: .normal)
            button.setTitleColor(.systemGray3, for: .normal)
            button.isUserInteractionEnabled = false
        }
        button.layer.borderColor = button.currentTitleColor.cgColor
    }
    
    func setupBrightness(brightness: UInt8) {
        brightSlider.value = Float(brightness)
    }
    
    func setupColor(color: String) {
        colorSlider.color = UIColor(hex: color)
    }
    
    func setConnected() {
        animationView.stop()
        animationView.removeFromSuperview()
        view.addSubview(modesCollectionView)
        view.addSubview(button)
    }
    
    func setConnecting() {
        view.addSubview(animationView)
        animationView.play()
    }
    
    func setDisconnected() {
        print(#function)
    }
}

extension SmartLightViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SmartLight.Mode.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = modesCollectionView.dequeueReusableCell(withReuseIdentifier: "SmartLightModeCell", for: indexPath) as? SmartLightModeCell else {
            return UICollectionViewCell()
        }
        
        let modes = SmartLight.Mode.allCases
        let mode = modes[indexPath.row]
        let isSelected = (mode == self.mode)
        
        cell.configure(with: mode.rawValue, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modes = SmartLight.Mode.allCases
        let mode = modes[indexPath.row]
        self.mode = mode
        
        presenter.didModeSelected(mode: mode)
        
        let cell = collectionView.cellForItem(at: indexPath)
            //Briefly fade the cell on selection
            UIView.animate(withDuration: 0.5,
                           animations: {
                            //Fade-out
                            cell?.alpha = 0.5
            }) { (completed) in
                UIView.animate(withDuration: 0.5,
                               animations: {
                                //Fade-out
                                cell?.alpha = 1
                })
            }
        collectionView.reloadData()
    }
}

extension SmartLightViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
}


