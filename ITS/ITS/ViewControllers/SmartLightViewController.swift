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
    private let deviceName: String
    
    private lazy var presenter = SmartLightPresenter(output: self)
    
    private let animationView = LottieAnimationView(name: "dots")
    private let rainbowView = LottieAnimationView(name: "rainbow")
    
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
    private let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
    private let lightView = UIImageView()
    private let colorView = UIView()
    
    
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
        animationView.isHidden = true
        
        rainbowView.contentMode = .scaleAspectFit
        rainbowView.loopMode = .loop
        rainbowView.isHidden = true
        
        modesCollectionView.delegate = self
        modesCollectionView.dataSource = self
        modesCollectionView.showsHorizontalScrollIndicator = false
        modesCollectionView.isHidden = true
        
        lightView.image = UIImage(systemName: "light.beacon.max")
        lightView.contentMode = .scaleAspectFill
        lightView.tintColor = .customDarkBlue
        lightView.layer.cornerRadius = view.frame.width / 4
        lightView.isHidden = true
        
        colorView.layer.cornerRadius = view.frame.width / 4
        colorView.isHidden = true
        
        colorSlider.addTarget(self, action: #selector(didColorSliderValueChangeStopped), for: .touchUpInside)
        colorSlider.addTarget(self, action: #selector(didColorValueChanged), for: .valueChanged)
        colorSlider.isHidden = true
        
        brightSlider.minimumValue = 0
        brightSlider.maximumValue = 255
        brightSlider.minimumTrackTintColor = .systemYellow
        brightSlider.minimumValueImage = UIImage(systemName: "sun.min.fill")
        brightSlider.tintColor = .systemYellow
        brightSlider.maximumValueImage = UIImage(systemName: "sun.max.fill")
        brightSlider.addTarget(self, action: #selector(didBrightSliderValueChangeStopped), for: .touchUpInside)
        brightSlider.addTarget(self, action: #selector(didBrightSliderValueChanged), for: .valueChanged)
        brightSlider.isHidden = true
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray6.cgColor
        button.layer.cornerRadius = 24
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        button.setTitleColor(.customDarkBlue, for: .normal)
        button.layer.borderColor = UIColor.systemGray6.cgColor
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.systemGray5.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.isHidden = true
        
        view.addSubview(animationView)
        view.addSubview(modesCollectionView)
        view.addSubview(lightView)
        view.addSubview(colorView)
        view.addSubview(rainbowView)
        view.addSubview(button)
        view.addSubview(colorSlider)
        view.addSubview(brightSlider)
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
        
        lightView.pin
            .below(of: modesCollectionView)
            .marginTop(80)
            .width(view.frame.width / 2)
            .height(view.frame.width / 2)
            .hCenter()
        
        colorView.pin
            .below(of: modesCollectionView)
            .marginTop(80)
            .width(view.frame.width / 2)
            .height(view.frame.width / 2)
            .hCenter()
        
        rainbowView.pin
            .below(of: modesCollectionView)
            .marginTop(80)
            .width(view.frame.width)
            .height(view.frame.width)
            .hCenter()
        
        button.pin
            .bottom(100)
            .height(64)
            .horizontally(120)
        
        colorSlider.pin
            .above(of: button)
            .marginBottom(50)
            .horizontally(32)
            .height(32)
        
        brightSlider.pin
            .above(of: button)
            .marginBottom(50)
            .horizontally(10)
    }
    
    @objc func didTapButton() {
        presenter.didStateChanged()
    }
    
    @objc func didBrightSliderValueChangeStopped() {
        presenter.didBrightnessChanged(brightness: brightSlider.value)
    }
    
    @objc func didBrightSliderValueChanged() {
        lightView.backgroundColor = .systemYellow.withAlphaComponent(CGFloat(brightSlider.value) / 255)
    }
    
    @objc func didColorSliderValueChangeStopped() {
        presenter.didColorChanged(color: colorSlider.color)
    }
    
    @objc func didColorValueChanged() {
        colorView.backgroundColor = colorSlider.color
    }
}

extension SmartLightViewController: SmartLightPresenterOutput {
    
    func setupMode(mode: SmartLight.Mode) {
        self.mode = mode
        switch mode {
        case .light:
            rainbowView.stop()
            rainbowView.isHidden = true
            colorSlider.isHidden = true
            colorView.isHidden = true
            brightSlider.isHidden = false
            lightView.isHidden = false
            
        case .multicolor:
            rainbowView.stop()
            rainbowView.isHidden = true
            lightView.isHidden = true
            brightSlider.isHidden = true
            colorSlider.isHidden = false
            colorView.isHidden = false
            
        case .rainbow:
            colorSlider.isHidden = true
            colorView.isHidden = true
            brightSlider.isHidden = true
            lightView.isHidden = true
            rainbowView.isHidden = false
            rainbowView.play()
        }
    }
    
    func setupState(state: SmartLight.State) {
        switch state {
        case .off:
            button.setTitle("ON", for: .normal)
            button.isUserInteractionEnabled = true
            button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
            brightSlider.isUserInteractionEnabled = false
            colorSlider.isUserInteractionEnabled = false
            
        case .on:
            button.setTitle("OFF", for: .normal)
            button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            button.isUserInteractionEnabled = true
            brightSlider.isUserInteractionEnabled = true
            colorSlider.isUserInteractionEnabled = true
            
        case .disconnected:
            button.setTitle("CHECKING...", for: .normal)
            button.setTitleColor(.systemGray3, for: .normal)
            button.isUserInteractionEnabled = false
        }
    }
    
    func setupBrightness(brightness: UInt8) {
        brightSlider.value = Float(brightness)
        lightView.backgroundColor = .systemYellow.withAlphaComponent(CGFloat(brightness) / 255)
    }
    
    func setupColor(color: String) {
        colorSlider.color = UIColor(hex: color)
        colorView.backgroundColor = UIColor(hex: color)
    }
    
    func setConnected() {
        animationView.stop()
        animationView.isHidden = true
        modesCollectionView.isHidden = false
        button.isHidden = false
    }
    
    func setConnecting() {
        animationView.isHidden = false
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


