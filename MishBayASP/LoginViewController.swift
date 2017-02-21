//
//  LoginViewController.swift
//  MishBayASP
//
//  Created by Sadie Lee on 2/20/17.
//  Copyright © 2017 Sadie Lee. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //let LoginUserURL = "http://srl17.sps.edu/LoginUser.php"
    let LoginUserURL = "http://localhost:8888/LoginUser.php"
    
    /*struct userInfo
     {
     static var userEmail = "hi"
     }*/
    
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
    
    @IBAction func loginTapped(_ sender: UIButton)
    {
        //Getting values from text fields
        let password = passwordTextField.text
        let email = emailTextField.text
        
        let requestURL = NSURL(string: LoginUserURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        let postParameters = "email="+email!+"&password="+password!;
        
        //Adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        //userInfo.userEmail = "user"
        
        if (password == "" || email == "")
        {
            self.emptyTextFieldAlert();
        }
        else
        {
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
                    let JSON = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                
                    //Parsing the json
                    if let parseJSON = JSON
                    {
                        var msg = ""
                    
                        //Getting the json response
                        msg = (parseJSON["message"] as! String?)!
                    
                        if msg == "User is registered"
                        {
                            DispatchQueue.main.async
                            {
                                self.performSegue(withIdentifier: "loginSegue", sender: self)
                            }
                        }
                    
                        if msg == "User is not found"
                        {
                            DispatchQueue.main.async
                            {
                                self.signinErrorAlert()
                            }
                        }
                    
                        //Printing the response
                        print(msg)
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
    
    @IBAction func signinErrorAlert()
    {
        let alertController = UIAlertController(title: "Error", message: "The information that you have provided does not match our records. Please try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func emptyTextFieldAlert()
    {
        let alertController = UIAlertController(title: "Empty textfield!", message: "Please fill out all the textfields", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

}
