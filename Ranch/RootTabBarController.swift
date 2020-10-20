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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
