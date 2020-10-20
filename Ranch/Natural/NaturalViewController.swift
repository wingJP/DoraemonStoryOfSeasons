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
    
    enum NaturalType :Int{
        case natural
        case crop
    }
    
    
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        if let type = NaturalType(rawValue: sender.selectedSegmentIndex) {
            self.type = type
        }
        
    }
    
    var type : NaturalType = .natural {
        didSet {
            loadBaseArray()
            loadData()
        }
    }
    
    var baseArray : [NaturalModelProtocol]!
    var dataArray : [NaturalModelProtocol]!
    let seasonList = ["全部","春季","夏季","秋季","冬季","四季"]
    
    var seasonSelected = 0 {
        didSet {
            loadData()
        }
    }
    
    func loadBaseArray() {
        switch type {
        case .natural: baseArray = (getList<NaturalModel>() as! [NaturalModelProtocol])
        case .crop: baseArray = (getList<CropModel>() as! [NaturalModelProtocol])
        default: baseArray = (getList<NaturalModel>() as! [NaturalModelProtocol])
        }
        
    }
    
    func loadData() {
        if seasonSelected == 0 {
            dataArray = baseArray
        }else {
            dataArray = baseArray.filter({ (natura) -> Bool in
                return natura.season == seasonSelected - 1
            })
        }
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CorpCell", for: indexPath) as! CropCell
            cell.model = model
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CorpCell", for: indexPath) as! CropCell
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = dataArray[indexPath.row]
        if model.isGift ,let vc = self.tabBarController as? RootTabBarController {
            vc.findRole(withGift: model.name)
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