//
//  RolesViewController.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/16.
//

import UIKit

class RolesViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    let types = ["全部","铁匠","木匠","医院","杂货","鸡屋","厨师","动物屋","鱼店","精灵","小动物","其它"]
    var selected = 0 {
        didSet {
            if selected == 0 {
                roles = RodesManage.list
            }else if selected == types.count - 1 {
                roles = RodesManage.list.filter({ (rode) -> Bool in
                    if let infoStr = rode.info {
                        return infoStr.contains("-")
                    }else {
                        return true
                    }
                })
            }else {
                let type = types[selected]
                roles = RodesManage.list.filter({ (rode) -> Bool in
                    if let infoStr = rode.info {
                        return infoStr.contains(type)
                    }
                    return false
                })
            }
            collection.reloadData()
        }
    }
    
    open func search(withGift gift: String) {
        roles = RodesManage.list.filter({ $0.like.firstIndex(where: {$0 == gift}) != nil || $0.favorite.firstIndex(where: {$0 == gift}) != nil})
        collection?.reloadData()
    }
    
    var roles = RodesManage.list
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.removeAllSegments()
        
        for (i, title) in types.enumerated() {
            segment.insertSegment(withTitle: title, at: i, animated: false)
        }
        segment.selectedSegmentIndex = selected
        // Do any additional setup after loading the view.
    }
    @IBAction func filterChange(_ sender: UISegmentedControl) {
        selected = sender.selectedSegmentIndex
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { _ in
                self.layout?.invalidateLayout()
            },
            completion: { _ in }
        )
    }
    
    fileprivate func resetLayout() {
        let width = (collection.frame.width - 30) / 2
        layout.itemSize = CGSize.init(width: width, height: 160)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetLayout()
    }

}

extension RolesViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        roles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoleCell", for: indexPath) as! RoleCell
        cell.model = roles[indexPath.row]
        return cell
    }
}



class RoleCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var hateLabel: UILabel!
    
    var model : Rode? {
        didSet {
            guard let model = model else {
                return
            }
            nameLabel.text = model.name
            infoLabel.text = model.info
            
            likeLabel.text = "3心: " +  model.like.joined(separator: ", ")
            favoriteLabel.text = "5心: " + model.favorite.joined(separator: ", ")
            hateLabel.text = "讨厌: " + model.hate.joined(separator: ", ")
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 20
        
    }
}
