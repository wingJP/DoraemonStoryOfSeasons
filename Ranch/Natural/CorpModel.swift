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
    
    var firstYear : Bool? = true
    
}

class CropCell : UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLable: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var sellLabel: UILabel!
    
    @IBOutlet weak var giftIcon: UIImageView!
    @IBOutlet weak var cookIcon: UIImageView!
    
    @IBOutlet weak var reButton: UIButton!
    
    @IBOutlet weak var yearButton: UIView!
    var model : CropModel? {
        didSet {
            guard let model = model else {
                return
            }
            nameLabel.text = model.name
            giftIcon.isHidden = !model.isGift
            cookIcon.isHidden = !model.canCook
            priceLabel.text = String(model.price)
            dayLabel.text = String(model.day) + " 天"
            sellLabel.text = String(model.sell)
            
            reButton.isHidden = model.repeat
            yearButton.isHidden = model.firstYear ?? false
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 20
//        self.reButton?.layer.cornerRadius = 2
    }
}
