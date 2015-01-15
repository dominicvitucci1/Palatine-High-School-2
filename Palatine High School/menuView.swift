//
//  menuView.swift
//  Palatine High School
//
//  Created by Dominic Vitucci on 11/24/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit

class menuView: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    
    
    
    
    override func loadView() {
        
        super.loadView()
        
        
        
        PFConfig.getConfigInBackgroundWithBlock
            {
                (config: PFConfig!, error: NSError!) -> Void in
                let menu = config["menuLink"] as String
                NSLog("Yay! The number is %@!", menu)
                
                let requestURL = NSURL(string: menu)
                
                let request = NSURLRequest(URL: requestURL!)
                
                self.webView.loadRequest(request)
        }

        
        
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    

}
