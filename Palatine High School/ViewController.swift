//
//  ViewController.swift
//  Palatine High School
//
//  Created by Dominic Vitucci on 11/23/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.titleView = UIImageView(image: UIImage(named: "Top Bar"))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func callNumber(sender: UIButton)
    {
        // Code for UIAlertView (ios7)
        
        var callUsAlert: UIAlertView = UIAlertView()
        
        callUsAlert.delegate = self
        
        callUsAlert.title = "Would you like to call the office?"
        callUsAlert.message = ""
        callUsAlert.addButtonWithTitle("Cancel")
        callUsAlert.addButtonWithTitle("Call")
        
        callUsAlert.show()
    
    }
    
    // Code for UIAlertView (iOS 7)
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        
        switch buttonIndex {
            
        case 1:
            self.phoneCall()
            NSLog("calling")
            
        default:
            println("alertView \(buttonIndex) clicked")
            
            
        }
        
        
    }
    
    func phoneCall()
    {
        let phone = "tel://18477551600";
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }

    
    
    
    
    
    
    


}

