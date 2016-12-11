//
//  TOCViewController.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/9/16.
//
//
import UIKit
import Foundation


class TcViewController: UIViewController {
    
    
    @IBAction func disagreePressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "The app will quit",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { action in
                                        exit(0)
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .default)
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func agreePressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Have you read and understood the Terms",
                                      message: "You will be held accountable",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { action in
                                        self.performSegue(withIdentifier: "showLogin", sender: nil)
                                        
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .default)
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        return
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
