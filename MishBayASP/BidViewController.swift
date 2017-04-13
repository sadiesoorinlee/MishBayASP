//
//  BidViewController.swift
//  MishBayASP
//
//  Created by Sadie Lee on 4/6/17.
//  Copyright © 2017 Sadie Lee. All rights reserved.
//

import Foundation
import UIKit

class BidViewController: UIViewController
{
    
    @IBOutlet weak var bidAmountTextField: UITextField!
    
    var id: String!
    let BidURL = "http://localhost:8888/Bid.php"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func bidTapped(_ sender: UIButton)
    {
        let bid = bidAmountTextField.text
        
        let requestURL = NSURL(string: BidURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        let postParameters = "id="+id!+"&bid="+bid!+"&name="+LoginViewController.Variables.name;
        
        //Adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        if (bid == "")
        {
            self.emptyTextFieldAlert()
        }
        
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
                //Converting resonse to NSDictionary
                let JSON = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                
                var msg = ""
                
                //Getting the json response
                msg = (JSON!["message"] as? String)!
                
                if msg == "Bid successfully"
                {
                    DispatchQueue.main.async
                        {
                            self.bidSuccessAlert()
                    }
                }
                
                if msg == "Bid amount must be higher than the current highest bid"
                {
                    DispatchQueue.main.async
                        {
                            self.bidFailureAlert()
                    }
                }
                
                //Printing the response
                print(msg)
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        //Executing the task
        task.resume()
    }
    
    @IBAction func emptyTextFieldAlert()
    {
        let alertController = UIAlertController(title: "Empty textfield!", message: "Please enter the bid amount", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bidSuccessAlert()
    {
        let alertController = UIAlertController(title: "Success", message: "You have bid successfully", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Yay!", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bidFailureAlert()
    {
        let alertController = UIAlertController(title: "Error", message: "Bid amount must be higher than the current highest bid", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
