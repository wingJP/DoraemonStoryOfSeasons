//
//  Menu.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/17.
//

import UIKit

struct Menu : Decodable{
    var name: String
    
    var price: Int
    var power: Int
    
    var tool: String?
    
    var food: [String]
    
    var isGift : Bool {
        return RodesManage.likeSet.contains(name)
    }
}


struct MenuManage {
    static var list : [Menu] =  {
        if let path = Bundle.main.url(forResource: "menu", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Menu].self, from: data)
                return jsonData
            } catch {
                return [Menu]()
            }
        }
        return [Menu]()
    }()
    
    static var cookSet : Set<String> = {
        var set = Set<String>()
        Self.list.forEach { (menu) in
            menu.food.forEach({ set.insert($0) })
        }
        return set
    }()
    
}
