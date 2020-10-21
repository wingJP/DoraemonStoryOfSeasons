//
//  CookViewController.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/17.
//

import UIKit

class CookViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var textField: UITextField!
    
    var menuList = MenuManage.list
    
    let toods = ["全部","锅具组","平底锅","擀面杖","打蛋器","烤箱","免工具"]
    
    @IBOutlet weak var segment: UISegmentedControl!
    var toolSelected = 0 {
        didSet {
            if toolSelected == 0 {
                menuList = MenuManage.list
            }else if toolSelected == toods.count - 1 {
                menuList = MenuManage.list.filter({ $0.tool == nil })
            }else {
                let tool = toods[toolSelected]
                menuList = MenuManage.list.filter({ $0.tool == tool })
            }
            collectionView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
        textField.resignFirstResponder()
    }
    
    open func search(withFood food: String) {
        menuList = MenuManage.list.filter({ $0.food.filter({$0 == food}).count > 0 })
        collectionView?.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        segment.removeAllSegments()
        for (i, title) in toods.enumerated() {
            segment.insertSegment(withTitle: title, at: i, animated: false)
        }
        segment.selectedSegmentIndex = toolSelected
        // Do any additional setup after loading the view.
    }
    @IBAction func filterChange(_ sender: UISegmentedControl) {
        toolSelected = sender.selectedSegmentIndex
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { _ in self.layout?.invalidateLayout() },
            completion: { _ in }
        )
    }
    
    fileprivate func resetLayout() {
        let width = (collectionView.frame.width - 30) / 2
        layout.itemSize = CGSize.init(width: width, height: 100)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetLayout()
    }
}


extension CookViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.model = menuList[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = menuList[indexPath.row]
        if model.isGift ,let vc = self.tabBarController as? RootTabBarController {
            vc.findRole(withGift: model.name)
        }
    }
}

extension CookViewController:  UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let keyword = textField.text,keyword.count > 0  {
            menuList = MenuManage.list.filter({ $0.name.contains(keyword) || $0.food.joined(separator: " ").contains(keyword) })
        }else{
            menuList = MenuManage.list
        }
        collectionView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text,keyword.count > 0  {
            menuList = MenuManage.list.filter({ $0.name.contains(keyword) || $0.food.joined(separator: " ").contains(keyword) })
        }else{
            menuList = MenuManage.list
        }
        collectionView.reloadData()
        textField.resignFirstResponder()
        return true
    }
}


class MenuCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    
    
    @IBOutlet weak var toolLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var giftIcon: UIImageView!
    
    var model : Menu? {
        didSet {
            guard let model = model else {
                return
            }
            nameLabel.text = model.name

            priceLabel.text = String(model.price)
            powerLabel.text = String(model.power)
            
            toolLabel.text = model.tool ?? "免工具"
            
            foodLabel.text = model.food.joined(separator: " + ")
            
            giftIcon.isHidden = !model.isGift
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 20
    }
}
