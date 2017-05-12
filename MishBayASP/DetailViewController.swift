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
    
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var row: Int!
    var id: String!
    var deadlineArray = [String]()
    var namesArray = [String]()
    var bidArray = [String]()
    var descriptionArray = [String]()
    var idArray = [String]()
    var imageArray = [UIImage]()
    let GetItemsURL = "http://srl17.sps.edu/GetItems.php"
    let GetImageURL = "http://srl17.sps.edu/GetImage.php"
    //let GetItemsURL = "http://localhost:8888/GetItems.php"
    //let GetImageURL = "http://localhost:8888/GetImage.php"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        let bidScene = segue.destination as! BidViewController //Set destination View Controller
        bidScene.id = id //Pass objects to destination View Controller
    }
    
    func getData()
    {
        let requestURL = NSURL(string: GetItemsURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        if self.namesArray.count > 0 || self.deadlineArray.count > 0 || self.bidArray.count > 0 || self.descriptionArray.count > 0 || self.idArray.count > 0 //Empty arrays
        {
            self.namesArray.removeAll(keepingCapacity: false)
            self.deadlineArray.removeAll(keepingCapacity: false)
            self.bidArray.removeAll(keepingCapacity: false)
            self.descriptionArray.removeAll(keepingCapacity: false)
            self.idArray.removeAll(keepingCapacity: false)
        }
        
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
                let myJSON : AnyObject! = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject! //Converting response
                
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
                        
                        if let description = ((JSONArray)[i] as? NSDictionary)?["description"] as? String
                        {
                            self.descriptionArray.append(description)
                        }
                        
                        if let id = ((JSONArray)[i] as? NSDictionary)?["ID"] as? String
                        {
                            self.idArray.append(id)
                        }
                        
                        i += 1
                    }
                    
                    DispatchQueue.main.async
                    {
                        self.fillLabels()
                        self.getImage()
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
    
    func getImage()
    {
        let requestURL = NSURL(string: GetImageURL)
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
                    
                    DispatchQueue.main.async
                    {
                        self.fillImageView()
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
    
    func fillImageView()
    {
        let image = imageArray[row]
        itemImageView.image = image
    }
    
}
