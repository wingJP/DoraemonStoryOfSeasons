//
//  CorpModel.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/20.
//

import UIKit
protocol BaseModel {
    static var fileKey: String { get }
}

protocol NaturalModelProtocol {
    var season: Int { get }
    
    var name : String { get }
    
    var isGift : Bool { get }
    
    var canCook : Bool { get }
}


func getList<T>(_ type: T.Type) -> [T] where T : Decodable, T: BaseModel {
    print(T.self.fileKey)
    if let path = Bundle.main.url(forResource: T.self.fileKey, withExtension: "json") {
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            print(T.self.fileKey + " load  \(data.count)")
            let jsonData = try decoder.decode([T].self, from: data)
            print(T.self.fileKey + " decode")
            return jsonData
        } catch {
            return [T]()
        }
    }
    return [T]()
}



struct CropModel: Decodable, BaseModel, NaturalModelProtocol {
    var season: Int
    
    var isGift : Bool {
        return RodesManage.likeSet.contains(name)
    }
    
    var canCook : Bool {
        return MenuManage.cookSet.contains(name)
    }
    
    static var fileKey: String { "crop" }
    
    var name : String
    
    var price : Int
    
    var sell : Int
    
    var day : Int
    
    var `repeat` = false
    
}

class CropCell : UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLable: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var sellLabel: UILabel!
    
    @IBOutlet weak var giftIcon: UIImageView!
    @IBOutlet weak var cookIcon: UIImageView!
    
    
    var model : CropModel? {
        didSet {
            guard let model = model else {
                return
            }
            nameLabel.text = model.name
            giftIcon.isHidden = !model.isGift
            cookIcon.isHidden = !model.canCook
            priceLabel.text = String(model.price)
            dayLabel.text = String(model.day) + "天"
            sellLabel.text = String(model.sell)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 20
    }
}
