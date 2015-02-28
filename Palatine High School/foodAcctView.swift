//
//  foodAcctView.swift
//  Palatine High School
//
//  Created by Dominic Vitucci on 2/28/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import UIKit


class foodAcctView: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    
    
    var urlPath = "https://campus.d211.org/campus/portal/township.jsp"
    
    
    
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
