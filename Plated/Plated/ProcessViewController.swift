//
//  ProcessViewController.swift
//  Plated
//
//  Created by Stefan Iarca on 5/9/16.
//  Copyright © 2016 Plated. All rights reserved.
//

import UIKit
import AVFoundation

class ProcessViewController: UIViewController, QRCodeReaderViewControllerDelegate, APIDelegate {

    let handler:RequestHandler = RequestHandler()

    @IBOutlet weak var completionLayerView: UIView!
    @IBOutlet weak var actionLayerView: UIView!
    @IBOutlet weak var searchLayerView: UIView!

    @IBOutlet weak var searchLoadingImageView: UIImageView!
    
    @IBOutlet weak var completeLoadingImageView: UIImageView!
    
    var reader:QRCodeReaderViewController {
        get {
            if(_reader == nil) {
                let builder = QRCodeViewControllerBuilder { builder in
                    builder.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
                    builder.showTorchButton = true
                }
                _reader = QRCodeReaderViewController(builder: builder)
            }
            return _reader!
        }
    }
    
    var _reader:QRCodeReaderViewController?
    
    
    override func viewWillAppear(animated: Bool) {
        
        handler.delegate = self
        
        if QRCodeReader.supportsMetadataObjectTypes() {
            //reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            self.addChildViewController(reader)
            reader.view.frame = self.view.frame
            self.view.addSubview(reader.view)
            reader.didMoveToParentViewController(self)
            self.view.sendSubviewToBack(reader.view)
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        handler.getTableID(result.value)
        beginSearching()
        //self.performSegueWithIdentifier("OptionsSegue", sender: nil)
        
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toggleTorch() {
        reader.toggleTorchAction()
    }
    @IBAction func turnCamera() {
        reader.switchCameraAction()
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callWaiter() {
    }
    @IBAction func askBill() {
    }
    
    func beginSearching(){
        self.searchLayerView.hidden = false
        self.searchLoadingImageView.animationImages = [UIImage(named:"loading1")!, UIImage(named:"loading2")!, UIImage(named:"loading3")!]
        self.searchLoadingImageView.animationDuration = 1
        
        self.searchLoadingImageView.startAnimating();
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        reader.removeFromParentViewController()
        _reader = nil;
        
        if self.completeLoadingImageView.isAnimating() {
            self.completeLoadingImageView.stopAnimating()
        }
        
        super.viewWillDisappear(animated)
    }
    func handlerDidGetResults(results:Array<AnyObject>?){
        if results == nil {
            print("No results")
            return;
        }
        print(results![0])
        NSUserDefaults.standardUserDefaults().setObject(results![0], forKey: "TableID");
        
        self.performSegueWithIdentifier("OptionsSegue", sender: nil)
        
    }
    func handlerDidFailWithError(error:NSError?,description:String?){
        
    }
    
}
