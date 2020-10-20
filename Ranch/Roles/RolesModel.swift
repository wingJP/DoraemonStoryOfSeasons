//
//  RolesModel.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/16.
//

import UIKit

struct Rode: Decodable {
    var name : String
    var info : String?
    
    var like: [String]
    var favorite: [String]
    var hate: [String]
}

struct RodesManage {
    static var list : [Rode] =  {
        if let path =  Bundle.main.url(forResource: "roles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Rode].self, from: data)
                return jsonData
            } catch {
                return [Rode]()
            }
        }
        return [Rode]()
    }()
    
    static var likeSet : Set<String> = {
        var set = Set<String>()
        Self.list.forEach { (rode) in
            rode.like.forEach({ set.insert($0) })
            rode.favorite.forEach({ set.insert($0) })
        }
        return set
    }()
    
}
