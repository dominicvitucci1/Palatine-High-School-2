//
//  schoolStoreView.swift
//  Palatine High School
//
//  Created by Dominic Vitucci on 11/24/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit

class schoolStoreView: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    var urlPath = "http://www.waistup.com/PHS_Pirate_Boosters"
    
    
    
    override func loadView() {
        
        super.loadView()
        
        
        
        loadURL()
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func loadURL()
        
    {
        
        let requestURL = NSURL(string: urlPath)
        
        let request = NSURLRequest(URL: requestURL!)
        
        webView.loadRequest(request)
        
        
        
    }


}
