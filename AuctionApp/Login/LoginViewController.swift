//
//  LoginViewController.swift
//  AuctionApp
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    var viewShaker:AFViewShaker?
    override func viewDidLoad() {
        super.viewDidLoad()

        viewShaker = AFViewShaker(viewsArray: [nameTextField, emailTextField])
        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        
        if nameTextField.text != "" && emailTextField.text != "" {
            
            var user = PFUser()
            user["fullname"] = nameTextField.text.lowercaseString
            user.username = emailTextField.text.lowercaseString
            user.password = "test"
            user.email = emailTextField.text.lowercaseString
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if succeeded == true {
                    self.registerForPush()
                    self.performSegueWithIdentifier("loginToItemSegue", sender: nil)
                } else {
                    let errorString = error.userInfo!["error"] as NSString
                    println("Error Signing up: \(error)")
                    PFUser.logInWithUsernameInBackground(user.username, password: user.password, block: { (user, error) -> Void in
                        if error == nil {
                            
                            self.registerForPush()
                            self.performSegueWithIdentifier("loginToItemSegue", sender: nil)
                        }else{
                            println("Error logging in ")
                            self.viewShaker?.shake()
                        }
                    })
                }
            }
            
        }else{
            //Can't login with nothing set
            viewShaker?.shake()
        }
    }
    
    
    func registerForPush() {
        let user = PFUser.currentUser()
        let currentInstalation = PFInstallation.currentInstallation()
        currentInstalation["email"] = user.email
        currentInstalation.saveInBackgroundWithBlock(nil)

        
        let application = UIApplication.sharedApplication()
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }else{
            let types: UIRemoteNotificationType = .Badge | .Alert | .Sound
            application.registerForRemoteNotificationTypes(types)
        }
        
    }
}
