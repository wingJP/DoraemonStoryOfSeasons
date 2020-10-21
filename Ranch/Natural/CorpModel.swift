//
//  CorpModel.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/20.
//

import UIKit


struct CropModel: Decodable, BaseModel, NaturalModelProtocol {
    var season: Int
    
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
