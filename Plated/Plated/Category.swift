//
//  Category.swift
//  iTec-Plated
//
//  Created by Stefan Iarca on 5/14/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

class Category: NSObject {

    var imageURLString:String?
    var name:String
    var id:String
    
    init(dict:NSDictionary) {
        self.imageURLString = dict.objectForKey("image_src_id") as? String
        self.name = dict.objectForKey("description") as! String
        self.id = String(dict.objectForKey("id") as! Int)
    }
    
}
