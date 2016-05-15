//
//  GoogleAPIHandler.swift
//  Food&Fuel Finder
//
//  Created by DMTC on 9/14/15.
//  Copyright © 2015 DMTC. All rights reserved.
//


import UIKit
import CoreLocation



protocol APIDelegate : NSObjectProtocol{
    func handlerDidGetResults(results:Array<AnyObject>?);
    func handlerDidFailWithError(error:NSError?,description:String?);
}

class RequestHandler: NSObject {
    let APIKey:String = "AIzaSyCBFhw1uo-RM5_aMEkrPYmWuXXVIGwL9Yw";
    //let ServerAPI = "http://82.196.7.116:3000/"
    let ServerAPI = "http://mobile.itec.ligaac.ro"
    
    var delegate: APIDelegate?;
    

    private func executeLocationQuery(withURL queryURL:NSURL,bodyString:String?,bodyJSON:NSData? ,respSelector:Selector){
        let request:NSMutableURLRequest = NSMutableURLRequest.init(URL: queryURL);
        let session = NSURLSession.sharedSession();

        if bodyString != nil || bodyJSON != nil{
            request.HTTPMethod = "POST";
            let body:NSData! = bodyJSON != nil ? bodyJSON : bodyString!.dataUsingEncoding(NSUTF8StringEncoding);
            if bodyJSON != nil {
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            request.HTTPBody = body;
        }else{
            request.HTTPMethod = "GET";
        }
        print(request);
        print(request.HTTPMethod);
        print(request.HTTPBody);
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: {(data, response, error) -> Void in
                
                if error != nil{
                    print("\(error)");
                    self.delegate?.handlerDidFailWithError(error!,description: nil);
                }
                
                //assert(data != nil, "RESPONSE DATA IS NIL");
                if data != nil{
                    
                    do{
                        if let responseDict = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.AllowFragments]) as? NSDictionary {
                            print(responseDict);
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSelector(respSelector, withObject: responseDict);
                                print(responseDict);
                            });
                            
                            
                        }else{
                            let responseDict = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.AllowFragments]) as? Array<NSDictionary>
                                print(responseDict);
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSelector(respSelector, withObject: responseDict);
                                    print(responseDict);
                                });

                        }
                    } catch let parseError{
                        print(parseError);
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
                
                print("Response: \(response)")
            }
        )
        
        task.resume()
    }
    

    
    internal func login(email:String, password:String ){
        
        executeLocationQuery(withURL: NSURL.init(string: ServerAPI + "/user")!, bodyString: "email=" + email + "&password=" + password ,bodyJSON: nil,  respSelector: Selector("parseLoginResponse:"));
        
    }
    
    internal func getCategories(){
        
        executeLocationQuery(withURL: NSURL.init(string: ServerAPI + "/categories")!, bodyString: nil, bodyJSON: nil , respSelector: Selector("parseCategoriesResponse:"));
        
    }
    internal func getProducts(categoryID:String?){
        
        executeLocationQuery(withURL: NSURL.init(string: ServerAPI + "/products/" + (categoryID != nil ? categoryID! : ""))!, bodyString: nil ,bodyJSON: nil, respSelector: Selector("parseProductsResponse:"));
        
    }
    
    internal func getTableID(token:String){
        executeLocationQuery(withURL: NSURL.init(string: ServerAPI + "/table")!, bodyString: "qr:" + token ,bodyJSON: nil, respSelector: Selector("parseTableResponse:"));
        
    }
    ///bill/:tableId
    internal func getBill(){
        executeLocationQuery(withURL: NSURL.init(string: ServerAPI + "/bill/" + (NSUserDefaults.standardUserDefaults().objectForKey("TableID")as! String))!, bodyString: nil , bodyJSON:nil, respSelector: Selector("parseBillResponse:"));
        
    }
    internal func placeOrder(products:Array<NSDictionary>){
        
        let uID = NSUserDefaults.standardUserDefaults().objectForKey("GuestID") as! String
        let tableID = NSUserDefaults.standardUserDefaults().objectForKey("TableID") as! String
        
        do {
            let data =  try NSJSONSerialization.dataWithJSONObject(products, options: NSJSONWritingOptions.PrettyPrinted)
            
            let responseDict = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers])
            print(responseDict)
            
            // here "decoded" is the dictionary decoded from JSON data
            executeLocationQuery(withURL: NSURL.init(string: ServerAPI + "/order" + "/" + uID + "/" + tableID)!, bodyString: nil, bodyJSON: data , respSelector: Selector("parseOrderResponse:"));
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    func parseLoginResponse(jsonResponse:NSDictionary){
        print(jsonResponse)
        let errorKey:String = jsonResponse.objectForKey("status") as! String;
        if errorKey == "not_found" {
            //delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let id = jsonResponse.objectForKey("user_id") as! Int;
            
            delegate?.handlerDidGetResults([String(id)]);
            
        }
        
    }
    func parseCategoriesResponse(jsonResponse:NSDictionary){
        print(jsonResponse)
        let errorKey:String = jsonResponse.objectForKey("status") as! String;
        if errorKey == "not_found" {
            //delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let categories = jsonResponse.objectForKey("categories") as! Array<NSDictionary>;
            
            delegate?.handlerDidGetResults(categories);
            
        }
        
    }
    func parseProductsResponse(jsonResponse:NSDictionary){
        print(jsonResponse)
        let errorKey:String = jsonResponse.objectForKey("status") as! String;
        if errorKey == "not_found" {
            //delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let categories = jsonResponse.objectForKey("produse") as? Array<NSDictionary>;
            
            delegate?.handlerDidGetResults(categories);
            
            
        }
        
    }
    func parseTableResponse(jsonResponse:NSDictionary){
        print(jsonResponse)
        let errorKey:String = jsonResponse.objectForKey("status") as! String;
        if errorKey == "error" {
            //delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let id = jsonResponse.objectForKey("tableId") as! Int;
            
            delegate?.handlerDidGetResults([String(id)]);
            
        }
        
    }
    func parseOrderResponse(jsonResponse:NSDictionary){
        print(jsonResponse)
        let errorKey:String = jsonResponse.objectForKey("status") as! String;
        if errorKey == "error" {
            //delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let ids = jsonResponse.objectForKey("orders_ids") as! Array<Int>;
            
            delegate?.handlerDidGetResults(ids);
            
        }
        
    }
    func parseBillResponse(jsonResponse:Array<NSDictionary>){
        print(jsonResponse)
        var prodArray:Array<Product> = []
        for dict:NSDictionary in jsonResponse{
            print(dict)
            let id = dict.objectForKey("product_id") as! Int
            let orderId = dict.objectForKey("delivered_order_id") as! Int
            let name = dict.objectForKey("product_name") as! String
            let unitPrice = dict.objectForKey("unit_price") as! String
            let quantity = dict.objectForKey("quantity") as! Int
            let price = dict.objectForKey("price") as! String
            
            print(orderId)
            prodArray.append(Product(dict: ["description" : name,"id" : id, "price" : unitPrice, "nrOrdered" : quantity ]))
        }
        delegate?.handlerDidGetResults(prodArray);
            
        
        
    }
    /*
    func parseRegisterResponse(jsonResponse:NSDictionary){
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let user = jsonResponse.objectForKey("user") as! NSDictionary;
            let key = user.objectForKey("api_key")
             NSUserDefaults.standardUserDefaults().setObject(key, forKey: "key");
            delegate?.handlerDidGetResults(nil);
        }
       
    }
    
    func parseAllIndicesResponse(jsonResponse:NSDictionary){
        print(jsonResponse);
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let valuesArray = jsonResponse.objectForKey("values") as! Array<NSDictionary>;
            var dataArray = Array<Data>();
            for dict in valuesArray{
                let entry = Data();
                entry.stringValue = dict.objectForKey("value") as! String;
                entry.timeStamp = dict.objectForKey("timestamp") as! String;
                dataArray.append(entry);
            }
            print(dataArray);
            delegate?.handlerDidGetResults(dataArray);
        }
    }
    
    func parseCategoryResponse(jsonResponse:NSDictionary){
        
        let indicesArray = jsonResponse.objectForKey("indices") as! Array<NSDictionary>;
        
        var categoryArray = Array<Category>();
        
        for dict in indicesArray {
            
            
        delegate?.handlerDidGetResults(categoryArray)
    }
    
    func parseUsersResponse(jsonResponse:NSDictionary){
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let valuesArray = jsonResponse.objectForKey("patients") as! Array<NSDictionary>;
            var usersArray = Array<User>();
            
            for dict in valuesArray{
                let entry = User();
                
                entry.uid = dict.objectForKey("uid") as? Int;
                entry.name = dict.objectForKey("name") as? String;
                entry.email = dict.objectForKey("email") as? String;
                
                usersArray.append(entry);
            }
            
            delegate?.handlerDidGetResults(usersArray);
        }
    }
    
    func parseAddUserResponse(jsonResponse:NSDictionary){
        let errorKey:Bool = jsonResponse.objectForKey("error") as! Bool;
        if errorKey == true {
            delegate?.handlerDidFailWithError(nil, description: (description: jsonResponse.objectForKey("error_details") as? String));
        }else{
            let valuesArray = jsonResponse.objectForKey("patients") as! Array<NSDictionary>;
            var usersArray = Array<User>();
            
            for dict in valuesArray{
                let entry = User();
                
                entry.uid = dict.objectForKey("uid") as? Int;
                entry.name = dict.objectForKey("name") as? String;
                entry.email = dict.objectForKey("email") as? String;
                
                usersArray.append(entry);
            }
            delegate?.handlerDidGetResults(usersArray);
        }
    }*/
}
