//
//  ViewController.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    let dayArray = ["一", "二","三","四","五","六","日"]
    let storeArray = ["铁匠屋","木匠屋","医院","杂货屋","养鸡场","料理屋","动物屋","钓鱼屋"]
    
    var weak = 0
    
    let timeDic:[[Int]] = [[0x0, 0x3380, 0x3380,0x3380,0x3380,0x3380,0x0],
                           [0x30f0, 0x0, 0x30f0,0x30f0,0x0,0x30f0,0x30f0],
                           [0x3380, 0x3380, 0x3380,0x0,0x3380,0x3000,0x0],
                           [0x01f0, 0x01f0, 0x01f0,0x0,0x01f0,0x01f0,0x01f0],
                           [0x7e00, 0x0, 0x7e00,0x7e00,0x0,0x7e00,0x7e00],
                           [0x0, 0x0f3c, 0x0f3c,0x0f3c,0x0,0x0f3c,0x0f3c],
                           [0x7700, 0x7700, 0x0,0x7700,0x0,0x7700,0x7700],
                           [0x0, 0xf300, 0x0, 0xf300, 0x0, 0xf300, 0xf300],
    ]
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { _ in
                self.layout.invalidateLayout()
            },
            completion: { _ in }
        )
    }
    var detailStatus = false {
        didSet {
            self.title = detailStatus ? ("周" + dayArray[weak]) : "商店时间"
            self.collection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let startTime = 7
    func key2Time(_ b: Int) -> [Int] {
        var times = [Int]()
        for i in (0..<16) {
            let j = 16 - i
            if b & (1 << j) != 0 {
                times.append(i + startTime)
            }
        }
        return times
    }
    func key2Lable(_ b: Int) -> [String] {
        var reArray = [String]()
        var minTime = 0
        var lastTime = 0
        for time in key2Time(b) {
            if minTime == 0 {
                minTime = time
                lastTime = time
            }else if time - 1 == lastTime {
                lastTime = time
            }else if time - lastTime > 1 {
                reArray.append("\(minTime) ~ \(lastTime+1)点")
                minTime = time
                lastTime = time
            }else{
                
            }
        }
        if minTime != lastTime {
            reArray.append("\(minTime) ~ \(lastTime+1)点")
        }
        return reArray
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if detailStatus {
            return 2
        }else{
            return 8
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return storeArray.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if detailStatus && indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCell", for: indexPath) as! TimeLineCell
                let offset = (collection.bounds.width / 8) * 7 / 32
                cell.initLable(offset: offset)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell
                if indexPath.row == 0 {
                    cell.nameLabel.text = ""
                }else{
                    cell.nameLabel.text = "周" + dayArray[indexPath.row - 1]
                }
                cell.backgroundColor = UIColor.systemGray6
                return cell
            }
        }else{
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as! StoreCell
                cell.nameLabel.text = storeArray[indexPath.section - 1]
                cell.backgroundColor = UIColor.systemGray5
                return cell
            }else{
                if detailStatus {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineCell2", for: indexPath) as! TimeLineCell
                    cell.initLable(index: timeDic[indexPath.section - 1][weak])
                    return cell
                }else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
                    let time = timeDic[indexPath.section - 1][indexPath.row - 1]
                    if time == 0 {
                        cell.timeLabel.text = "关闭"
                        cell.timeLabel2.isHidden = true
                        cell.backgroundColor = UIColor.init(hex: 0xff6670)
                    }else{
                        let arr = key2Lable(time)
                        if arr.count > 0 {
                            cell.timeLabel.text = arr[0]
                        }
                        if arr.count > 1 {
                            cell.timeLabel2.isHidden = false
                            cell.timeLabel2.text = arr[1]
                        }else{
                            cell.timeLabel2.isHidden = true
                        }
                        cell.backgroundColor = UIColor.init(hex: 0x77a88d)
                    }
                    return cell
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collection.frame.width / 8
        if detailStatus {
            if indexPath.section == 0 {
                return .init(width: width * (indexPath.row == 0 ? 1 : 7), height: width * 0.3)
            }else {
                return .init(width: width * (indexPath.row == 0 ? 1 : 7), height: width * 0.5)
            }
        }else {
            if indexPath.section == 0 {
                return .init(width: width, height: width * 0.3)
            }else {
                return .init(width: width, height: width * 0.5)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if indexPath.row > 0 {
            weak = indexPath.row - 1
            detailStatus = !detailStatus
        }
    }

    
}
class StoreCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    override func prepareForReuse() {
        self.backgroundColor = UIColor.lightGray
    }
}

class WeekCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class TimeCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
}


class TimeLineCell: UICollectionViewCell {
    @IBOutlet weak var stackView: UIStackView!
    func initLable(offset: CGFloat) {
        if stackView.arrangedSubviews.count == 0 {
            for i in 8..<24 {
                let label = UILabel()
                label.text = "\(i)"
                label.font = .systemFont(ofSize: 14)
                label.textAlignment = .center
                stackView.addArrangedSubview(label)
            }
        }
        stackView.transform = CGAffineTransform.init(translationX: offset, y: 0)
    }
    func initLable(index: Int) {
        if stackView.arrangedSubviews.count == 0 {
            for _ in 8..<24 {
                let view = UIView()
                stackView.addArrangedSubview(view)
            }
        }
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            let j = 16 - i
            if index & (1 << j) != 0 {
                view.backgroundColor = UIColor.init(hex: 0x77a88d)
            }else{
                view.backgroundColor = UIColor.init(hex: 0xff6670)
            }
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
