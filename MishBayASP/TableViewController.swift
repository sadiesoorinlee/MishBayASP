//
//  TableViewController.swift
//  MishBayASP
//
//  Created by Sadie Lee on 2/21/17.
//  Copyright © 2017 Sadie Lee. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController
{
    
    var deadlineArray = [String]()
    var namesArray = [String]()
    var bidArray = [String]()
    var imageArray = [UIImage]()
    var count:Int?
    var name:String = LoginViewController.Variables.name
    var refresh = UIRefreshControl()
    //let GetItemsURL = "http://srl17.sps.edu/GetItems.php"
    let GetItemsURL = "http://localhost:8888/GetItems.php"
    let GetImageURL = "http://localhost:8888/GetImage.php"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(TableViewController.getItems), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        getItems()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        getItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return imageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TableViewCellController
        
        let bid = bidArray[indexPath.row]
        cell.bidLabel?.text = bid
        
        let deadline = deadlineArray[indexPath.row]
        cell.deadlineLabel?.text = deadline
        
        let name = namesArray[indexPath.row]
        cell.nameLabel?.text = name
        
        let image = imageArray[indexPath.row]
        cell.itemImageView?.image = image
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let detailScene = segue.destination as! DetailViewController //Set destination View Controller
        
        if let indexPath = self.tableView.indexPathForSelectedRow //Passs object to destination View Controller
        {
            detailScene.row = Int(indexPath.row)
        }
    }
    
    func getItems()
    {
        let requestURL = NSURL(string: GetItemsURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) //Creating task to send post request
        {
            (data, response, error) in
            
            guard error == nil else
            {
                print(error!)
                return
            }
            
            do //Parsing response
            {
                let myJSON : AnyObject! = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject!
                
                if self.namesArray.count > 0 || self.deadlineArray.count > 0 || self.bidArray.count > 0 //Empty arrays
                {
                    self.namesArray.removeAll(keepingCapacity: false)
                    self.deadlineArray.removeAll(keepingCapacity: false)
                    self.bidArray.removeAll(keepingCapacity: false)
                }
                
                if let JSONArray : NSArray = myJSON as? NSArray
                {
                    var i = 0
                    while i<JSONArray.count
                    {
                        if let name = ((JSONArray)[i] as? NSDictionary)?["name"] as? String
                        {
                            self.namesArray.append(name)
                        }
                        
                        if let deadline = ((JSONArray)[i] as? NSDictionary)?["deadline"] as? String
                        {
                            self.deadlineArray.append(deadline)
                        }
                        
                        if let bid = ((JSONArray)[i] as? NSDictionary)?["highest_bid"] as? String
                        {
                            self.bidArray.append(bid)
                        }
                        
                        i += 1
                    }
                }
                
                DispatchQueue.main.async
                {
                    self.getImage()
                    self.tableView.reloadData()
                }
            }
            catch
            {
                print(error)
            }
        }
        
        task.resume() //Executing task
        refresh.endRefreshing()
    }
    
    func getImage()
    {
        let requestURL = NSURL(string: GetImageURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) //Creating task to send the post request
        {
            (data, response, error) in
            
            guard error == nil else
            {
                print(error!)
                return
            }
            
            do //Parsing response
            {
                let myJSON : AnyObject! = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject!
                
                if self.imageArray.count > 0 //Empty imageArray
                {
                    self.imageArray.removeAll(keepingCapacity: false)
                }
                
                if let JSONArray : NSArray = myJSON as? NSArray
                {
                    var i = 0
                    while i<JSONArray.count
                    {
                        if let pictureString = ((JSONArray)[i] as? NSDictionary)?["picture"] as? String
                        {
                            let data = NSData(base64Encoded: pictureString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                            let picture = UIImage(data: data! as Data)
                            self.imageArray.append(picture!)
                        }
                        
                        i += 1
                    }
                }
            }
            catch
            {
                print(error)
            }
        }
        
        task.resume() //Executing task
    }
    
}
