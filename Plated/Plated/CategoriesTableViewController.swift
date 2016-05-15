//
//  CategoriesTableViewController.swift
//  iTec-Plated
//
//  Created by Stefan Iarca on 5/14/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController, APIDelegate {

    var categoriesArray:Array<Category> = []
    let handler:RequestHandler = RequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        handler.delegate = self
        self.navigationItem.title = "Categories"
        self.navigationController?.navigationBarHidden = false;
        handler.getCategories();
        
        

    }
    
   
    
    func designStuff(){
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "lato-regular", size: 18)!, NSForegroundColorAttributeName : UIColor.blackColor()]

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
        return self.categoriesArray.count + 1
    }

    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        if indexPath.row == 0{
            cell.textLabel!.text = "TOATE"
            cell.imageView!.image = UIImage(named: "icon")
        }else{
            let category = self.categoriesArray[indexPath.row - 1];
            cell.textLabel?.text = category.name;
            
            if category.imageURLString != nil{
                let url = NSURL(fileURLWithPath: category.imageURLString!);
                let data = NSData(contentsOfURL:url);
                cell.imageView!.image = UIImage(data: data!)
                
            }else{
                cell.imageView!.image = UIImage(named: "icon")
            }        }

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("ProductSegue", sender: ["name" : "All Products"])
        }else{
            self.performSegueWithIdentifier("ProductSegue", sender: ["id" : self.categoriesArray[indexPath.row - 1].id, "name" : self.categoriesArray[indexPath.row - 1].name])
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProductSegue" {
            let dvc = segue.destinationViewController as! ProductsTableViewController
            
            dvc.categoryID = sender!["id"] as? String
            dvc.categoryName = sender!["name"] as! String
        }
    }
 
    
    // MARK: - API Delegate
    func handlerDidGetResults(results:Array<AnyObject>?){
        if results == nil {
            print("No results")
            return;
        }
        let castedResuts = results as! Array<NSDictionary>
        for dict:NSDictionary in castedResuts{
            
            self.categoriesArray.append(Category(dict: dict))
            
        }
        self.tableView.reloadData()
        let footer = UIImageView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100))
        footer.image = UIImage(named: "bottom")
        self.tableView.tableFooterView = footer
        
    }
    func handlerDidFailWithError(error:NSError?,description:String?){
        
    }
    @IBAction func goToBasket(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("BasketTVC") as! BasketTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
