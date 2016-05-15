//
//  LoginViewController.swift
//  Plated
//
//  Created by Stefan Iarca on 5/9/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, APIDelegate {

    let handler:RequestHandler = RequestHandler()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var keyboard: NSLayoutConstraint!
    var keyboardHidden:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.delegate = self
       
        // Do any additional setup after loading the view.
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor(), NSFontAttributeName :  UIFont(name: "lato-italic", size: 18)!])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor(), NSFontAttributeName :  UIFont(name: "lato-italic", size: 18)!])
        passwordTextField.secureTextEntry = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func skipLogin() {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("GuestID") == nil {
            //handler.login("c9@ligaac.ro", password: "parola9");
            handler.login(emailTextField.text!, password: passwordTextField.text!)
        }else{
            self.performSegueWithIdentifier("QRSegue", sender: nil)
        }
    }
    
    // MARK: - API Delegate
    func handlerDidGetResults(results:Array<AnyObject>?){
        if results == nil {
            print("No results")
            return;
        }
        NSUserDefaults.standardUserDefaults().setObject(results![0], forKey: "GuestID");
        
        self.performSegueWithIdentifier("QRSegue", sender: nil)
        
    }
    
    func handlerDidFailWithError(error:NSError?,description:String?){
        let alertController: UIAlertController! = UIAlertController(title: "Errpr", message: description, preferredStyle: UIAlertControllerStyle.Alert)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        if keyboardHidden == false {
            return;
        }
        keyboardHidden = false
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.keyboard.constant += keyboardHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.commitAnimations()
        
    }
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        if keyboardHidden == true {
            return;
        }
        keyboardHidden = true;
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.keyboard.constant -= keyboardHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.commitAnimations()
        
    }
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        if emailTextField.isFirstResponder(){
            emailTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder(){
            passwordTextField.resignFirstResponder()
        }
    }
}
