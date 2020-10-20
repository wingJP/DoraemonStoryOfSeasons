//
//  NaturalModel.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/17.
//

import UIKit

struct NaturalModel: Decodable, NaturalModelProtocol, BaseModel {
    static var fileKey: String { "natural" }
    
    var name : String
    var info : String?
    
    var price : Int
    var season : Int
    
    var position : [String]
    
    var isGift : Bool {
        return RodesManage.likeSet.contains(name)
    }
    
    var canCook : Bool {
        return MenuManage.cookSet.contains(name)
    }
}

struct NaturalManage {
    static func color(for position: String) -> UIColor {
        if position.contains("海") {
            return UIColor.init(hex: 0x5BCCAF)
        }
        if position.contains("镇") {
            return UIColor.init(hex: 0x663d1a)
        }
        if position.contains("森") {
            return UIColor.init(hex: 0x557858)
        }
        if position.contains("河") || position.contains("湖") || position.contains("瀑布")  {
            return UIColor.init(hex: 0x36a3fe)
        }
        if position.contains("山") {
            return UIColor.init(hex: 0xB3926E)
        }
        return UIColor.darkGray
    }
}

class NaturalCell : UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLable: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var giftIcon: UIImageView!
    @IBOutlet weak var cookIcon: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    var model : NaturalModel? {
        didSet {
            guard let model = model else {
                return
            }
            nameLabel.text = model.name
            infoLable.text = model.info
            giftIcon.isHidden = !model.isGift
            cookIcon.isHidden = !model.canCook
            priceLabel.text = String(model.price)
            
            model.position.forEach { (title) in
                stackView.addArrangedSubview({
                    let color = NaturalManage.color(for: title)
                    let btn = UIButton(type: .system)
                    btn.setTitle(title, for: .normal)
                    btn.backgroundColor = color.withAlphaComponent(0.3)
                    btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
                    btn.tintColor = color
                    btn.layer.borderColor = color.cgColor
                    btn.layer.borderWidth = 0.5
                    btn.layer.cornerRadius = 4
                    return btn
                }())
            }
            stackView.addArrangedSubview({
                let view = UIView()
                view.setContentHuggingPriority(.defaultLow, for: .horizontal)
                return view
            }())
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 20
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeFullyAllArrangedSubviews()
    }
}
