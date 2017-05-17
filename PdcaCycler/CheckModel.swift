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
    dynamic var name = ""// Plan名
    dynamic var text = ""// 説明
    dynamic var startDate: NSDate!// 開始日
    dynamic var endDate: NSDate!// 終了日
    
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
