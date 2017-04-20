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
    var image:UIImage?
    var count:Int?
    var name:String = LoginViewController.Variables.name
    var refresh = UIRefreshControl()
    //let GetItemsURL = "http://srl17.sps.edu/GetItems.php"
    let GetItemsURL = "http://localhost:8888/GetItems.php"
    
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
        return namesArray.count
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
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Set the destination View Controller
        let detailScene = segue.destination as! DetailViewController
        
        //Pass the selected object to the destination View Controller
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            detailScene.row = Int(indexPath.row)
        }
    }
    
    func getItems()
    {
        let requestURL = NSURL(string: GetItemsURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        //Creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            (data, response, error) in
            
            guard error == nil else
            {
                print(error!)
                return
            }
            
            //Parsing the response
            do
            {
                let myJSON : AnyObject! = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject!
                
                if self.namesArray.count > 0 || self.deadlineArray.count > 0 || self.bidArray.count > 0
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
                        //Create an array of names
                        if let name = ((JSONArray)[i] as? NSDictionary)?["name"] as? String
                        {
                            self.namesArray.append(name)
                        }
                        
                        //Create an array of deadlines
                        if let deadline = ((JSONArray)[i] as? NSDictionary)?["deadline"] as? String
                        {
                            self.deadlineArray.append(deadline)
                        }
                        
                        //Create an array of highest bids
                        if let bid = ((JSONArray)[i] as? NSDictionary)?["highest_bid"] as? String
                        {
                            self.bidArray.append(bid)
                        }
                        
                        i += 1
                    }
                }
                
                DispatchQueue.main.async
                    {
                        self.tableView.reloadData()
                }
            }
            catch
            {
                
                print(error)
            }
            
        }
        
        //Executing the task
        task.resume()
        
        refresh.endRefreshing()
    }
    
    func getImage()
    {
        //Creating NSURL
        let requestURL = NSURL(string: GetItemsURL)
        
        //Creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //Setting the method to post
        request.httpMethod = "GET"
        
        //Creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            
            if error != nil
            {
                print("error is \(String(describing: error))")
                return;
            }
            
            //Parsing the response
            do
            {
                //Converting resonse to NSDictionary
                let myJSON : AnyObject! = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject!
                if let JSONArray : NSArray = myJSON as? NSArray
                {
                    var i = 0
                    while i<JSONArray.count
                    {
                        //Create an array of
                        if let name = ((JSONArray)[i] as? NSDictionary)?["name"] as? String
                        {
                            self.namesArray.append(name)
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
        
        //Executing the task
        task.resume()
    }
    
}
