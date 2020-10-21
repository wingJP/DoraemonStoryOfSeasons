//
//  RootTabBarController.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/17.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func findRole(withGift gift: String) {
        if let nvc = self.viewControllers![1] as? UINavigationController,
           let vc = nvc.viewControllers.first as? RolesViewController {
            self.selectedIndex = 1
            vc.search(withGift: gift)
        }
    }
    
    func findMenu(withfood food: String) {
        if let nvc = self.viewControllers![3] as? UINavigationController,
           let vc = nvc.viewControllers.first as? CookViewController {
            self.selectedIndex = 3
            vc.search(withFood: food)
        }
    }


}
