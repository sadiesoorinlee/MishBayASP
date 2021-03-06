//
//  SignUpViewController.swift
//  MishBayASP
//
//  Created by Sadie Lee on 2/14/17.
//  Copyright © 2017 Sadie Lee. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController
{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let CreateUserURL = "http://srl17.sps.edu/CreateUser.php"
    //let CreateUserURL = "http://localhost:8888/CreateUser.php"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpTapped(_ sender: UIButton)
    {
        let name = nameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        let requestURL = NSURL(string: CreateUserURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        let postParameters = "name="+name!+"&password="+password!+"&email="+email!;
        request.httpBody = postParameters.data(using: String.Encoding.utf8) //Adding parameters to request body
        request.httpMethod = "POST"

        if (name == "" || password == "" || email == "")
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
            
                if msg == "User created successfully"
                {
                    DispatchQueue.main.async
                    {
                        self.signUpSuccessAlert()
                    }
                }
                    
                if msg == "Could not create user"
                {
                    DispatchQueue.main.async
                    {
                        self.signUpFailureAlert()
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
        let alertController = UIAlertController(title: "Empty textfield!", message: "Please fill out all the textfields", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpSuccessAlert()
    {
        let alertController = UIAlertController(title: "Success", message: "You have successfully signed up", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Yay!", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpFailureAlert()
    {
        let alertController = UIAlertController(title: "Failure", message: "You were unable to sign up. Please try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

}
