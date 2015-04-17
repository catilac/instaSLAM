//
//  PhotosViewController.swift
//  instaSLAM
//
//  Created by Chirag Dave on 4/16/15.
//  Copyright (c) 2015 Chirag Davé. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var photos = NSMutableArray()
    var refreshControl = UIRefreshControl()
    var clientId = "6b7da4300e464523b332a09d592de043"
    var madeRequest = false
    var scrollLoader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = view.bounds.size.width
        tableView.tableFooterView = scrollLoader

        fetchPhotos()

        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func fetchPhotos(index: Int = 0) {
        madeRequest = true
        if(index == 0) {
            self.photos.removeAllObjects()
        }
        
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)&start=\(index)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            self.photos.addObjectsFromArray(responseDictionary["data"] as! NSArray as [AnyObject])
            self.tableView.reloadData()
            self.madeRequest = false
            self.scrollLoader.stopAnimating()
            
            println("response: \(self.photos)")
        }
    }
    
    func onRefresh() {
        fetchPhotos()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        let photo = photos[indexPath.section] as! NSDictionary
        let imageURL = photo.valueForKeyPath("images.standard_resolution.url") as! String
        cell.photo.image = nil
        cell.photo.setImageWithURL(NSURL(string: imageURL))
        
        if(indexPath.section == photos.count - 1 && !madeRequest) {
            scrollLoader.startAnimating()
            
            fetchPhotos(index: photos.count - 1)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 50))
        
        header.backgroundColor = UIColor.whiteColor()
        
        let profilePhoto = UIImageView(frame: CGRectMake(5, 5, 40, 40))
        profilePhoto.layer.cornerRadius = 20.0
        let user = photos[section] as! NSDictionary
        let userPhotoURL = NSURL(string: user.valueForKeyPath("user.profile_picture") as! String)
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.borderColor = UIColor.blackColor().CGColor
        profilePhoto.layer.borderWidth = 1
        profilePhoto.setImageWithURL(userPhotoURL)
        
        header.addSubview(profilePhoto)
        
        let title = UILabel(frame: CGRect(x: 55, y: 0, width: view.frame.size.width - 55, height: 50))
        let username = user.valueForKeyPath("user.username") as! String
        title.text = "@\(username)"
        title.textColor = UIColor.blackColor()
        header.addSubview(title)
        
        return header
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! PhotoCell
        let destVC = segue.destinationViewController as! PhotosDetailViewController
        destVC.photoSource = cell.photo.image
        
    }

}
