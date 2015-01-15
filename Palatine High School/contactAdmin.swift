//
//  contactAdmin.swift
//  Palatine High School
//
//  Created by Dominic Vitucci on 1/14/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import UIKit

class contactAdmin: UIViewController {

    
    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    
    
    
    override func loadView() {
        
        super.loadView()
        
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        PFConfig.getConfigInBackgroundWithBlock
            {
                (config: PFConfig!, error: NSError!) -> Void in
                let contact = config["zcontactLink"] as String
                
                self.webView.loadHTMLString(contact, baseURL: nil)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    

}
