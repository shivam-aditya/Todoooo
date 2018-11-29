//
//  Category.swift
//  Todoooo
//
//  Created by Shivam Aditya on 23/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColor : String = ""
    var items = List<Item>()
}

