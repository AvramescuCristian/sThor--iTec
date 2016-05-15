//
//  Product.swift
//  iTec-Plated
//
//  Created by Stefan Iarca on 5/14/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    var imageURLString:String?
    var name:String
    var id:String
    var price:String
    var categoryID:String?
    var additional:String?
    var nrOrdered = 0

    init(dict:NSDictionary) {
        print(dict)
        self.imageURLString = dict.objectForKey("image_src_id") as? String
    
        self.name = dict.objectForKey("description") as! String
        let idTry = dict.objectForKey("id") as? String
        if idTry != nil {
            self.id = idTry!
        }else{
            self.id = String(dict.objectForKey("id") as! Int)
        }
        self.price = dict.objectForKey("price") as! String
        self.categoryID = dict.objectForKey("category_id") as? String
        self.additional = dict.objectForKey("additional") as? String
        
        let orderedTry = dict.objectForKey("nrOrdered") as? String
        
        if orderedTry != nil {
            self.nrOrdered = Int(orderedTry!)!
        }else{
            let orderedTryInt = dict.objectForKey("nrOrdered") as? Int
            if orderedTryInt != nil {
                self.nrOrdered = orderedTryInt!
            }else{
                self.nrOrdered = 0
            }
        }
        
        if self.imageURLString == "" {
            self.imageURLString = nil
        }
        if self.additional == "" {
            self.additional = nil
        }
        if self.categoryID == "" {
            self.categoryID = nil
        }
        
        
    }
    
    
    func toDict() -> NSDictionary {
        let objectsArray = [self.name,self.id,self.price,(imageURLString != nil ? imageURLString! : ""), (categoryID != nil ? categoryID! : ""),(additional != nil ? additional! : ""),String(nrOrdered)]
        let keysArray = ["description","id","price","image_src_id","category_id", "additional","nrOrdered"]

        return NSDictionary(objects: objectsArray, forKeys: keysArray)
    }
    
    
    
}

