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


func getList<T>() -> [T] where T : Decodable, T: BaseModel {
    if let path = Bundle.main.url(forResource: T.self.fileKey, withExtension: "json") {
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([T].self, from: data)
            return jsonData
        } catch {
            return [T]()
        }
    }
    return [T]()
}



struct CropModel: Decodable, BaseModel, NaturalModelProtocol {
    var season: Int
    
    var isGift: Bool
    
    var canCook: Bool
    
    static var fileKey: String { "crop" }
    
    var name : String
    
    var price : Int
    
    var sell : Int
    
    var day : Int
    
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
