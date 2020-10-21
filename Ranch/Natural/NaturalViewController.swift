//
//  NaturalViewController.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/17.
//

import UIKit

class NaturalViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        if let type = NaturalType(rawValue: sender.selectedSegmentIndex) {
            self.type = type
        }
        
    }
    
    var type : NaturalType = .natural {
        didSet {
            loadData()
        }
    }
    
    let viewModel = NaturalViewModel()
    var dataArray : [NaturalModelProtocol]! = []
    let seasonList = ["全部","春季","夏季","秋季","冬季","四季"]
    
    var seasonSelected = 0 {
        didSet {
            loadData()
        }
    }
    
    func loadData() {
        if seasonSelected == 0 {
            dataArray = viewModel.getList(withType: type)
        }else {
            dataArray = viewModel.getList(withType: type).filter({ (natura) -> Bool in
                return natura.season == seasonSelected - 1
            })
        }
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func seasonChange(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        seasonList.enumerated().forEach { (index, title) in
            ac.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
                self.seasonSelected = index
                sender.title = title
            }))
        }
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(ac, animated: true)
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

extension NaturalViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = dataArray[indexPath.row] as? NaturalModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NaturalCell", for: indexPath) as! NaturalCell
            cell.model = model
            return cell
        }else if let model = dataArray[indexPath.row] as? CropModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CropCell", for: indexPath) as! CropCell
            cell.model = model
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CropCell", for: indexPath) as! CropCell
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let vc = self.tabBarController as? RootTabBarController  else {
            return
        }
        let model = dataArray[indexPath.row]
        if model.canCook && model.isGift {
            let ac = UIAlertController(title: "跳转", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "查询送礼角色", style: .default, handler: { (_) in
                vc.findRole(withGift: model.name)
            }))
            ac.addAction(UIAlertAction(title: "查询菜谱", style: .default, handler: { (_) in
                vc.findMenu(withfood: model.name)
            }))
            ac.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in }))
            present(ac, animated: true)
        }else if model.isGift {
            vc.findRole(withGift: model.name)
        }else if model.canCook {
            vc.findMenu(withfood: model.name)
        }
    }
}




extension UIStackView {

    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }

}
