//
//  OrderedTableViewController.swift
//  iTec-Plated
//
//  Created by Stefan Iarca on 5/14/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

class OrderedTableViewController: UITableViewController, APIDelegate {

    let handler:RequestHandler = RequestHandler()
    var billArray:Array<Product> = []
    var payForMyself = true
    
    let header = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 60))
    let headerLabel = UILabel(frame: CGRectMake(8,20,UIScreen.mainScreen().bounds.size.width - 8,20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        handler.delegate = self

        self.navigationController?.navigationBarHidden = false;
        self.navigationItem.title = "Bill"
        
        let basket = UIBarButtonItem(
            title: "Ask For Bill",
            style: .Plain,
            target: self,
            action: #selector(OrderedTableViewController.askBill)
        )
        
        
        self.navigationItem.rightBarButtonItem = basket
        
        headerLabel.font = UIFont(name: "lato", size: 18)

        header.addSubview(headerLabel)
        headerLabel.textAlignment = .Center
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var goodToCopy:Bool = true
        var delete:Bool = true
        var indexesToRemove:Array<Int> = []
        
        self.handler.getBill()
        
        /*if self.basket != nil{
            
            /*for (var i = 0; i < self.billArray.count; i += 1 ) {
                let sndProd = self.billArray[i]
                delete = true
                for productDict in self.basket! {
                    if Product(dict: productDict).id == sndProd {
                        delete = false
                    }
                    if delete {
                        indexesToRemove.append(i)
                    }
                }
            }
            for i in indexesToRemove {
                self.billArray.removeAtIndex(i)
            }*/
            
            for productDict in self.basket! {
                goodToCopy = true
                for sndProd in self.billArray {
                    if sndProd.id == Product(dict: productDict).id{
                        goodToCopy = false
                    }
                }
                if goodToCopy{
                    billArray.append(Product(dict: productDict))
                }
            }
            var total:Double = 0.0
         
        }
        else{
            billArray = []
            tableView.tableHeaderView = nil
        }
        tableView.reloadData()*/

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
        return billArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let product = billArray[indexPath.row]
        
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    func handlerDidGetResults(results:Array<AnyObject>?){
        if results == nil {
            print("No results")
            return;
        }
        
        let castedResuts = results as! Array<Product>
        self.billArray = []
        for prod in castedResuts{
            self.billArray.append(prod)
        }
        
        self.tableView.reloadData()
        
        var total:Double = 0.0
        for sndProd in self.billArray {
            total += Double(sndProd.nrOrdered) * Double(sndProd.price)!
        }
        headerLabel.text = "Total: " + String(total) + " lei"
        tableView.tableHeaderView = header
        
        let footer = UIImageView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        footer.image = UIImage(named: "bottom")
        self.tableView.tableFooterView = footer
        
        
    }
    func handlerDidFailWithError(error:NSError?,description:String?){
        
    }
    func askBill(){
        let alertController: UIAlertController! = UIAlertController(title: "Ask Bill", message: "Would you like to pay for yourself or for the entire table?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let myself = UIAlertAction(title: "For Myself", style: .Default, handler: { action in
            self.payForMyself = true
            
        })
        let full = UIAlertAction(title: "For the Entire Table", style: .Default, handler: { action in
            self.payForMyself = false
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(myself);
        alertController.addAction(full);
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
