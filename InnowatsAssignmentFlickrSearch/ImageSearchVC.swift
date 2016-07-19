//
//  ViewController.swift
//  InnowatsAssignmentFlickrSearch
//
//  Created by Innowats on 20/07/16.
//  Copyright © 2016 Alok Kumar Singh. All rights reserved.
//


import UIKit

class ImageSearchVC: UIViewController {

    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var collectionView : UICollectionView!
    var searchResults = NSMutableArray()

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
        self.title = "Search"
        collectionView?.registerNib(UINib(nibName: "ImageViewCollectionVewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCollectionVewCell")
    }

    func updateUserInterfaceOnScreen(){
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.reloadData()
    }

    // MARK: - UICollection View Delegate & Datasource
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int{
        return searchResults.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(collectionView.bounds.width/4,collectionView.bounds.width/4)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0;
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0;
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: ImageViewCollectionVewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageViewCollectionVewCell", forIndexPath: indexPath) as! ImageViewCollectionVewCell
        let imageDetails = searchResults.objectAtIndex(indexPath.row) as! NSDictionary
        if let url_z = imageDetails.objectForKey("url_z") as? String{
            cell.iconImageView.sd_setImageWithURL(NSURL(string:url_z))
        }else if let url_q = imageDetails.objectForKey("url_q") as? String {
            cell.iconImageView.sd_setImageWithURL(NSURL(string:url_q))
        }
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let imageDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageDetailVC") as! ImageDetailVC
        imageDetailVC.imageDetails = searchResults.objectAtIndex(indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(imageDetailVC, animated: true)
    }
    
    //MARK: - Action methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if (searchText as NSString).length>0 {
            performSearch()
            self.collectionView?.reloadData()
        } else {
            searchResults.removeAllObjects()
            self.collectionView?.reloadData()
        }
    }
    
    func performSearch() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(ImageSearchVC.performSearchPrivate), object: nil)
        self.performSelector(#selector(ImageSearchVC.performSearchPrivate), withObject: nil, afterDelay: 1.2)
    }
    
    func performSearchPrivate() {
        self.collectionView?.reloadData()
        if (searchBar.text! as NSString).length>0 {
            AksFlickrSearchHelper.sharedInstance.searchFlickrForImagesWithTag(searchBar.text!, completion: { (returnedData) in
                if let photosArray = returnedData as? NSMutableArray {
                    self.setDataFromArray(photosArray)
                }else{
                    self.setDataFromArray(NSMutableArray())
                }
            })
        }
    }
    
    func setDataFromArray(results:NSMutableArray?){
        self.searchResults = results!
        self.collectionView?.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

