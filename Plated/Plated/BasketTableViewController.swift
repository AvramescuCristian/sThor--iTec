//
//  BasketTableViewController.swift
//  iTec-Plated
//
//  Created by Stefan Iarca on 5/14/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

class BasketTableViewController: UITableViewController, APIDelegate, UITextViewDelegate {

    let handler:RequestHandler = RequestHandler()
    
    let basket:Array<NSDictionary> = NSUserDefaults.standardUserDefaults().objectForKey("Basket") as! Array<NSDictionary>
    var basketProducts:Array<Product> = []
    
    let header = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 150))
    let headerLabel = UILabel(frame: CGRectMake(20,20,120,20))
    let customStepper = UIStepper (frame:CGRectMake(UIScreen.mainScreen().bounds.size.width - 20 - 90, 20, 0, 0))
    let headerTextView = UITextView(frame: CGRectMake(20, 50, UIScreen.mainScreen().bounds.size.width - 20, 50))
    
    var editingCellRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        for productDict in basket {
            basketProducts.append(Product(dict: productDict))
        }
        handler.delegate = self
        let orderButton = UIBarButtonItem(
            title: "Order",
            style: .Plain,
            target: self,
            action: #selector(BasketTableViewController.order)
        )
        self.navigationItem.rightBarButtonItem = orderButton
        
        self.navigationItem.backBarButtonItem?.title = " "
        
        headerLabel.font = UIFont(name: "lato", size: 18)
        
        customStepper.wraps = true
        customStepper.autorepeat = false
        customStepper.maximumValue = 10
        customStepper.stepValue = 1
        customStepper.addTarget(self, action: #selector(BasketTableViewController.stepperValueChanged(_:)), forControlEvents: .ValueChanged)
        header.addSubview(headerLabel)
        header.addSubview(customStepper)
        header.addSubview(headerTextView)
        
        headerTextView.delegate = self;
        
        let footer = UIImageView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        footer.image = UIImage(named: "bottom")
        self.tableView.tableFooterView = footer
        
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
        return basketProducts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let product = basketProducts[indexPath.row]
        
        cell.textLabel?.text = product.name;
        if product.nrOrdered != 1 {
            cell.detailTextLabel?.text = String(product.nrOrdered) + " x " + product.price;
        }else {
            cell.detailTextLabel?.text = product.price;
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
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if headerTextView.isFirstResponder(){
            headerTextView.resignFirstResponder()
        }
        if editingCellRow == indexPath.row {
            tableView.tableHeaderView = nil
            headerTextView.text = "Enter Other Options..."
            editingCellRow = -1
        }else{
            
            editingCellRow = indexPath.row
            tableView.tableHeaderView = header
            headerLabel.text = "Nr Ordered: " + String(basketProducts[indexPath.row].nrOrdered)
            customStepper.value = Double(basketProducts[indexPath.row].nrOrdered)
            headerTextView.text = basketProducts[indexPath.row].additional != nil ? basketProducts[indexPath.row].additional : "Enter Other Options..."
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if headerTextView.isFirstResponder(){
            headerTextView.resignFirstResponder()
        }
        
        //
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
    
    func order(){
        var dict:Array<NSDictionary> = []
        for basketItem in basketProducts {
            dict.append(NSDictionary(objects: [String(basketItem.id), String(basketItem.nrOrdered),basketItem.additional != nil ? basketItem.additional! : ""], forKeys: ["productId","quantity","observations" ]))
        }
        handler.placeOrder(dict)
    }
    
    // MARK: - API Delegate
    func handlerDidGetResults(results:Array<AnyObject>?){
        if results == nil {
            print("No results")
            return;
        }
        print(results)
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("GuestID") as! String
        var crtLinks = NSUserDefaults.standardUserDefaults().objectForKey("Links") as? Dictionary<String, String>
        if crtLinks == nil{
            crtLinks = [:]
        }
        for orderID in results as! Array<Int> {
            crtLinks![String(orderID)] = userID
        }
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Basket")
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        let footer = UIImageView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        footer.image = UIImage(named: "bottom")
        self.tableView.tableFooterView = footer
        
    }
    func handlerDidFailWithError(error:NSError?,description:String?){
        
    }
    func stepperValueChanged(sender:UIStepper!)
    {
        let newVal = Int(sender.value)
        
        headerLabel.text = "Nr Ordered: " + String(newVal)
        basketProducts[editingCellRow].nrOrdered = newVal
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: editingCellRow, inSection: 0)], withRowAnimation: .None)
        updateDBase()
    }
    
    func updateDBase(){

        var newArray:Array<NSDictionary> = []
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Basket")
        for product in basketProducts {
            newArray.append(product.toDict())
        }
        NSUserDefaults.standardUserDefaults().setObject(newArray, forKey: "Basket")
    }
    
    func textViewDidChange(textView: UITextView) {
        basketProducts[editingCellRow].additional = textView.text
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter Other Options..." {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" || textView.text == nil {
            textView.text = "Enter Other Options..."
        }
        updateDBase()
    }
}
