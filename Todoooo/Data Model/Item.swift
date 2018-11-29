//
//  ListItem.swift
//  Todoooo
//
//  Created by Shivam Aditya on 20/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

//class Item : Encodable, Decodable {
//    
//    var title : String = ""
//    var done : Bool = false
//    
//}

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
