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
    let BidURL = "http://srl17.sps.edu/Bid.php"
    //let BidURL = "http://localhost:8888/Bid.php"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func bidTapped(_ sender: UIButton)
    {
        let bid = bidAmountTextField.text
        let requestURL = NSURL(string: BidURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        let postParameters = "id="+id!+"&bid="+bid!+"&name="+LoginViewController.Variables.name;
        request.httpBody = postParameters.data(using: String.Encoding.utf8) //Adding parameters to request body
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
            
            do //Parsing response
            {
                let JSON = try JSONSerialization.jsonObject(with: data!) as? [String: Any] //Converting response
                var msg = ""
                msg = (JSON!["message"] as? String)! //Getting json response
                
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
                
                print(msg) //Printing response
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        task.resume() //Executing task
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
