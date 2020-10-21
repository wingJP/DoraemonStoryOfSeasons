//
//  NaturalViewModel.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/21.
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
extension NaturalModelProtocol {
    var isGift : Bool {
        return RodesManage.likeSet.contains(name)
    }
    var canCook : Bool {
        return MenuManage.cookSet.contains(name)
    }
}

enum NaturalType : Int {
    case natural
    case crop
}
extension NaturalType {
    var model :BaseModel.Type {
        switch self {
        case .natural:  return NaturalModel.self
        case .crop:     return CropModel.self
        }
    }
}

class NaturalViewModel: NSObject {
    private var cacheDic = [String: [NaturalModelProtocol]]()
    
    func getList(withType type: NaturalType ) -> [NaturalModelProtocol] {
        let model = type.model
        if let arr = cacheDic[model.fileKey] {
            return arr
        }else {
            var arr = [NaturalModelProtocol]()
            switch type {
            case .natural: arr = getListInFile(NaturalModel.self)
            case .crop: arr = getListInFile(CropModel.self)
            }
            cacheDic[model.fileKey] = arr
            return arr
        }
    }
    
    
    private func getListInFile<T>(_ type: T.Type) -> [T] where T : Decodable, T: BaseModel {
        if let path = Bundle.main.url(forResource: T.self.fileKey, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                print(T.self.fileKey + " load  \(data.count)")
                let jsonData = try decoder.decode([T].self, from: data)
                return jsonData
            } catch {
                return [T]()
            }
        }
        return [T]()
    }
    
}
