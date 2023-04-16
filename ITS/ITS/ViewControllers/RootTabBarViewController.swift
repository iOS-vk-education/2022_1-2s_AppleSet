//
//  RootTabBarViewController.swift
//  ITS
//
//  Created by Natalia on 30.11.2022.
//

import UIKit

class RootTabBarViewController: UITabBarController, RootTabBarDelegate {

    let tabBarNormalImages = ["list.bullet.rectangle", "folder.badge.person.crop"]
    let tabBarSelectedImages = ["list.bullet.rectangle.fill", "folder.fill.badge.person.crop"]
    let tabBarTitles = ["All devices", "Groups"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = RootTabBar()
        tabBar.addDelegate = self
        self.setValue(tabBar, forKey: "tabBar")
        self.setRootTabbarConntroller()

    }

    func addClick() {
        if (self.tabBar.selectedItem?.title == "All devices") {
            
            let alertController = AddDeviceAlertController()
            
            alertController.onAddAction(completion: { name, type, id in
                AllDevicesViewController().addDeviceCell(with: CreateDeviceData(name: name, type: type, deviceID: id))
            })
            
            present(alertController, animated: true)
            
        } else {
            let alertController  = UIAlertController(title: "Add group", message: "Input group`s name", preferredStyle: .alert)

            alertController.addTextField()

            let okAction = UIAlertAction(title: "Add", style: .default) { _ in
                guard let text = alertController.textFields?.first?.text else {
                    return
                }

                GroupsViewController().addGroupCell(with: text)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true)
        }
    }
    
    func setRootTabbarConntroller(){
        
        self.tabBar.tintColor = .tapBarbutton // bottom button
        self.tabBar.backgroundColor = .tapBarBackground
        
        var vc: UIViewController?
        
        for i in 0..<self.tabBarNormalImages.count {

            switch i {
            case 0:
                vc = AllDevicesViewController()
            case 1:
                vc = GroupsViewController()
            default:
                break
            }

            let nav = RootNavigationController.init(rootViewController: vc!)

            let barItem = UITabBarItem.init(title: self.tabBarTitles[i], image: UIImage.init(systemName: self.tabBarNormalImages[i])?.withTintColor(.TextOnnavigationBar, renderingMode: .alwaysOriginal), selectedImage: UIImage.init(systemName: self.tabBarSelectedImages[i])?.withRenderingMode(.alwaysOriginal))
            
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.customLightGrey], for: .normal)
            barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.customGrey], for: .selected)

            vc?.title = self.tabBarTitles[i]

            vc?.tabBarItem = barItem

            self.addChild(nav)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

protocol RootTabBarDelegate: NSObjectProtocol {
    func addClick()
}

class RootTabBar: UITabBar {
    
    weak var addDelegate: RootTabBarDelegate?
    
    private lazy var addButton: UIButton = {
        return UIButton()
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addButton.setBackgroundImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        addButton.addTarget(self, action: #selector(RootTabBar.addButtonClick), for: .touchUpInside)
        
        self.addSubview(addButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButtonClick(){
        if addDelegate != nil {
            addDelegate?.addClick()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let buttonX = self.frame.size.width / 3
        var index = 0
        for barButton in self.subviews{
            
            if barButton.isKind(of: NSClassFromString("UITabBarButton")!){
                
                if index == 1{
                    addButton.frame.size = CGSize.init(width: 50, height: 50)
                    addButton.center = CGPoint.init(x: self.center.x, y: self.frame.size.height / 2 - 7)
                    index += 1
                }
                barButton.frame = CGRect.init(x: buttonX * CGFloat(index) + 47
                                              , y: 17, width: 37, height: 44)

                index += 1
                
            }
        }
        self.bringSubviewToFront(addButton)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isHidden {
            return super.hitTest(point, with: event)
            
        } else {
            let onButton = self.convert(point, to: self.addButton)
            if self.addButton.point(inside: onButton, with: event){
                return addButton
            } else {
                return super.hitTest(point, with: event)
            }
        }
    }
}

class RootNavigationController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSetting()
        
    }
    
    func defaultSetting() {
        
        view.backgroundColor = .navigationBarBackground
        self.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.backgroundColor = .red ///??
        self.navigationBar.tintColor = .red
        self.toolbar.tintColor = .red
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextOnnavigationBar,
                                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize:17)]
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 {
            viewController.tabBarController?.tabBar.isHidden=true
            
            let backButton = UIButton(frame:CGRect.init(x:15, y: 2, width: 30, height: 40))
            backButton.setImage(UIImage.init(systemName:"arrow.backward"), for: UIControl.State.normal)
            backButton.addTarget(self, action:#selector(self.didBackButton(sender:)), for: UIControl.Event.touchUpInside)
            backButton.sizeToFit()
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:backButton)
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func didBackButton(sender:UIButton) {
        self.popViewController(animated:true)
    }
}

