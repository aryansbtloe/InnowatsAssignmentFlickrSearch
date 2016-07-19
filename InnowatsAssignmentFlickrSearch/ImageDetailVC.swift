//
//  ImageDetailVC.swift
//  InnowatsAssignmentFlickrSearch
//
//  Created by Innowats on 20/07/16.
//  Copyright © 2016 Alok Kumar Singh. All rights reserved.
//


import UIKit

class ImageDetailVC: UIViewController {

    @IBOutlet var imageView : UIImageView!
    var imageDetails : NSDictionary!

    //MARK: - view controller life cycle methods
    
    override func prefersStatusBarHidden() -> Bool {
        if (self.navigationController != nil) {
            return (self.navigationController?.navigationBarHidden)!
        }else{
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startupInitialisations()
        setupForNavigationBar()
        registerForNotifications()
        updateUserInterfaceOnScreen()
    }
    
    //MARK: - other methods
    func setupForNavigationBar(){
    }
    
    func registerForNotifications(){
    }
    
    func startupInitialisations(){
        self.title = "Detail"
    }

    func updateUserInterfaceOnScreen(){
        if let url_z = imageDetails.objectForKey("url_z") as? String {
            imageView.sd_setImageWithURL(NSURL(string:url_z))
        }else if let url_q = imageDetails.objectForKey("url_q") as? String {
            imageView.sd_setImageWithURL(NSURL(string:url_q))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

