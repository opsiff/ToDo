//
//  ChecklistItem.swift
//  ToDo
//
//  Created by GUAN on 2019/2/27.
//  Copyright © 2019 GUAN. All rights reserved.
//

import Foundation
class ChecklistItem : NSObject, Codable{
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    func toggleChecked() {
        checked = !checked
    }
}
