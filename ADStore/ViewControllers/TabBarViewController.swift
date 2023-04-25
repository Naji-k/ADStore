//
//  TabBarViewController.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/19/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    @IBOutlet weak var tabbar: AppTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
        /**
         let controller1 = CategoryViewController()
         controller1.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
         let nav1 = UINavigationController(rootViewController: controller1)
         
         let controller2 = FavoritesViewController()
         controller2.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
         let nav2 = UINavigationController(rootViewController: controller2)
         
         let controller3 = AddPostViewController()
         controller3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
         controller3.modalPresentationStyle = .overFullScreen
         let nav3 = UINavigationController(rootViewController: controller3)
         
         let controller4 = MessagesViewController()
         controller4.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)
         let nav4 = UINavigationController(rootViewController: controller4)
         
         let controller5 = ProfileViewController()
         controller5.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 5)
         let nav5 = UINavigationController(rootViewController: controller5)
         
         
         //         let tabBarController = UITabBarController()
         //         tabBarController.viewControllers = [controller1, controller2, controller3, controller4, controller5]
         
         
         viewControllers = [nav1, nav2, nav3]
         //         **/
        DispatchQueue.main.async {
        }
        self.setupMiddleButton()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Disable when click behind the + button
        self.tabBar.items![2].isEnabled = false
        self.navigationController?.isNavigationBarHidden = false
        
    }
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50 , height: 50))
        let screenHeight = UIScreen.main.bounds.size.height
        print(screenHeight)
        menuButton.frame.origin.y = tabbar.bounds.height/2 - menuButton.frame.height / 1.5
        menuButton.frame.origin.x = tabbar.bounds.width/2 - menuButton.frame.width / 2
        
        //        if screenHeight > 736 {
        //            menuButton.frame.origin.y = view.bounds.height - tabbar.frame.size.height -  menuButton.frame.height
        //        } else {
        //            menuButton.frame.origin.y = view.bounds.height - tabbar.frame.size.height -  menuButton.frame.height / 2
        //
        //        }
        //
        //        menuButton.frame.origin.x = view.bounds.width/2 - menuButton.frame.size.width/2
        menuButton.frame = menuButton.frame
        
      //  menuButton.backgroundColor = UIColor(named: "TintGreenColor")
        menuButton.layer.cornerRadius = menuButton.frame.height/2
        tabbar.insertSubview(menuButton, at: 0)
        menuButton.setImage(UIImage(named: "add-90"), for: .normal)
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    @objc private func menuButtonAction(sender: UIButton) {
        guard let newVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") else {return}
        //        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        let navController = UINavigationController(rootViewController: newVC)
        navController.modalPresentationStyle = .overCurrentContext
        navController.modalTransitionStyle = .coverVertical
        self.present(navController, animated: true, completion: nil)
        
    }
    // disable when click on tabBar Button to reload it 
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if tabBarController.selectedIndex == 1 {
//            return viewController != tabBarController.selectedViewController
//        } else {
//        return true
//        }
//    }
    
}

@IBDesignable
class AppTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = #colorLiteral(red: 0.9782002568, green: 0.9782230258, blue: 0.9782107472, alpha: 1)
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 86.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
        path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 50
//        return sizeThatFits
//    }
//}

//}


