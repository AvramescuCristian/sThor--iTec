//
//  ProductsTableViewController.swift
//  iTec-Plated
//
//  Created by Stefan Iarca on 5/14/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, APIDelegate {

    var productArray:Array<Product> = []
    let handler:RequestHandler = RequestHandler()
    var categoryID:String?
    var categoryName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        handler.delegate = self
        self.navigationController?.navigationBarHidden = false;
        handler.getProducts(categoryID)
        self.navigationItem.title = self.categoryName
        
        /*let basket = UIBarButtonItem(
            title: "Basket",
            style: .Plain,
            target: self,
            action: #selector(ProductsTableViewController.goToBasket)
        )*/
        //create a new button
        let button: UIButton = UIButton(type:UIButtonType.Custom)
        //set image for button
        button.setImage(UIImage(named: "Basket"), forState: UIControlState.Normal)
        //add function for button
        button.addTarget(self, action: #selector(ProductsTableViewController.goToBasket), forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        button.frame = CGRectMake(0, 0, 30, 30)
        
        let basket = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        
        self.navigationItem.rightBarButtonItem = basket
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.productArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let product = self.productArray[indexPath.row];
        cell.textLabel?.text = product.name;
        cell.detailTextLabel?.text = product.price + "lei";
        
        if productIsInBasket(product) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        if product.imageURLString != nil{
            let url = NSURL(fileURLWithPath: product.imageURLString!);
            let data = NSData(contentsOfURL:url);
            cell.imageView!.image = UIImage(data: data!)
            
        }else{
            cell.imageView!.image = UIImage(named: "icon")
        }

        return cell
    }
    override func tableView(_tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let product = self.productArray[indexPath.row]
        
        if productIsInBasket(product) {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            removeProductFromBasket(product)
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            addProductInBasket(product)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - API Delegate
    func handlerDidGetResults(results:Array<AnyObject>?){
        if results == nil {
            print("No results")
            return;
        }
        let castedResuts = results as! Array<NSDictionary>
        
        for dict:NSDictionary in castedResuts{
            print(dict);
            self.productArray.append(Product(dict: dict))
            
        }
        self.tableView.reloadData()
        
        
        let footer = UIImageView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        footer.image = UIImage(named: "bottom")
        self.tableView.tableFooterView = footer
    }
    func handlerDidFailWithError(error:NSError?,description:String?){
        
    }
    
    func goToBasket(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("BasketTVC") as! BasketTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func productIsInBasket(product:Product) -> Bool{
        let products = NSUserDefaults.standardUserDefaults().objectForKey("Basket") as? Array<NSDictionary>
        if products == nil {
            return false
        }
        for orderedProduct in products! {
            if orderedProduct.objectForKey("id") as! String == product.id {
                return true
            }
        }
        return false
    }
    
    func addProductInBasket(product:Product){
        var products = NSUserDefaults.standardUserDefaults().objectForKey("Basket") as? Array<NSDictionary>
        
        if products == nil {
            products = []
        }
        product.nrOrdered = 1
        products?.append(product.toDict())
        NSUserDefaults.standardUserDefaults().setObject(products, forKey: "Basket")
        
    }
    func removeProductFromBasket(product:Product){
        var products = NSUserDefaults.standardUserDefaults().objectForKey("Basket") as? Array<NSDictionary>
        if products == nil {
            return
        }
        for (var i = 0; i < products!.count; i += 1) {
            let orderedProduct = products![i]
            if orderedProduct.objectForKey("id") as! String == product.id {
                products?.removeAtIndex(i)
                break
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(products, forKey: "Basket")
        
    }
}
