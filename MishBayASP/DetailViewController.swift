//
//  DetailViewController.swift
//  MishBayASP
//
//  Created by Sadie Lee on 2/21/17.
//  Copyright © 2017 Sadie Lee. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController
{
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var row: Int!
    var id: String!
    let GetItemsURL = "http://srl17.sps.edu/GetItems.php"
    var deadlineArray = [String]()
    var namesArray = [String]()
    var bidArray = [String]()
    var descriptionArray = [String]()
    var idArray = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayData()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        //Set the destination View Controller
        let bidScene = segue.destination as! BidViewController
        
        //Pass objects to the destination View Controller
        bidScene.row = row
        bidScene.bid = Int(bidLabel.text!)
        bidScene.id = id
    }*/
    
    func displayData()
    {

        let requestURL = NSURL(string: GetItemsURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        //Creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            
            if error != nil
            {
                print("error is \(error)")
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
                        
                        //Create an array of descripsions
                        if let descripsion = ((JSONArray)[i] as? NSDictionary)?["description"] as? String
                        {
                            self.descriptionArray.append(descripsion)
                        }
                        
                        if let descripsion = ((JSONArray)[i] as? NSDictionary)?["description"] as? String
                        {
                            self.descriptionArray.append(descripsion)
                        }
                        
                        if let descripsion = ((JSONArray)[i] as? NSDictionary)?["ID"] as? String
                        {
                            self.idArray.append(descripsion)
                        }
                        
                        i += 1
                    }
                    
                    DispatchQueue.main.async {
                        self.fillLabels();
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
    
    func fillLabels()
    {
        let bid = bidArray[row]
        bidLabel?.text = bid
        
        let deadline = deadlineArray[row]
        deadlineLabel?.text = deadline
        
        let name = namesArray[row]
        nameLabel?.text = name
        
        let description = descriptionArray[row]
        descriptionLabel?.text = description
        
        id = idArray[row]
    }
    
}
