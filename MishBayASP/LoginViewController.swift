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
    let LoginUserURL = "http://srl17.sps.edu/LoginUser.php"
    //let LoginUserURL = "http://localhost:8888/LoginUser.php"
    
    var username: String! //Save user's name as a variable
    {
        didSet
        {
            Variables.name = username
        }
    }
    
    struct Variables
    {
        static var name:String = ""
    }
    
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
        let password = passwordTextField.text
        let email = emailTextField.text
        let requestURL = NSURL(string: LoginUserURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        let postParameters = "email="+email!+"&password="+password!;
        request.httpBody = postParameters.data(using: String.Encoding.utf8) //Adding parameters to request body
        request.httpMethod = "POST"
        
        if (password == "" || email == "")
        {
            self.emptyTextFieldAlert();
        }
        else
        {
            let task = URLSession.shared.dataTask(with: request as URLRequest) //Creating task to send post request
            {
                (data, response, error) in
                
                guard error == nil else
                {
                    print(error!)
                    return
                }
                
                do //Parsing the response
                {
                    let JSON = try JSONSerialization.jsonObject(with: data!) as? [String: Any] //Converting response
                    var msg = ""
                    msg = (JSON!["message"] as? String)! //Getting json response
                    
                    if msg == "User login successful"
                    {
                        DispatchQueue.main.async
                        {
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                            self.username = (JSON!["name"] as? String)! //Store user's name
                        }
                    }
                    
                    if msg == "User login unsuccessful"
                    {
                        DispatchQueue.main.async
                        {
                            self.signinErrorAlert()
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
