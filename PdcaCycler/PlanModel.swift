//
//  PlanModel.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/17.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

// PlanModel
class PlanModel: Object {
    
    // Realmのインスタンス化
    static let realm = try! Realm()
    
    // プロパティ
    dynamic var id = ""// id
    dynamic var name = ""// Plan名
    dynamic var text = ""// 説明
    dynamic var startDate: NSDate!// 開始日
    dynamic var endDate: NSDate!// 終了日
    
    // アソシエーション
    dynamic var owner: GoalModel?// GoalModelに紐付いている
    let checks = List<CheckModel>()// CheckModelを複数持っている
    
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
