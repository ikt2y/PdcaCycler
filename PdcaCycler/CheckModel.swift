//
//  CheckModel.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/17.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class CheckModel: Object {
    
    // Realmのインスタンス化
    static let realm = try! Realm()
    
    // プロパティ
    dynamic var id = ""// id
    dynamic var memo = ""// メモ
    dynamic var keep = ""// Keep(振り返りでよかったこと/続けたいこと)
    dynamic var problem = ""// Problem(振り返りで悪かったこと)
    dynamic var try = ""// Try(振り返りで改善策、次のPlan)
    dynamic var createdDate: NSDate!// 振り返り日
    
    // アソシエーション
    dynamic var owner: PlanModel?// PlanModelに紐付いている
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // auto increment
    func getLastID() -> Int{
        let realm = try! Realm()
        let checkModel: NSArray = Array(realm.objects(CheckModel.self).sorted(byKeyPath: "id")) as NSArray
        let last = checkModel.lastObject
        if checkModel.count > 0 {
            let lastID = (last as AnyObject).value(forKey: "id") as? Int
            return lastID! + 1
        } else {
            return 1
        }
    }
    
}
