//
//  Testing.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/28/16.
//
//




import Foundation

func containsSwearWord(text: String, swearWords: [String]) -> Bool {
    return swearWords
        .reduce(false) { $0 || text.contains($1.lowercased()) }
}

// example usage
let listOfSwearWords = ["darn", "crap", "newb"]
/* list as lower case */

let userEnteredText1 = "This darn didelo thread is a no no."
let userEnteredText2 = "This fine didelo thread is a go."

print(containsSwearWord(text: userEnteredText1, swearWords: listOfSwearWords)) // true
print(containsSwearWord(text: userEnteredText2, swearWords: listOfSwearWords)) // false


@IBAction func viewProfile(_ sender: AnyObject){
    let alert = UIAlertController(title: "Whoops! New Feature Alert",
                                  message: "Please stay tuned for new updates",
                                  preferredStyle: .alert)
    
    let okayAction = UIAlertAction(title: "Okay, I can't wait",
                                   style: .default) { _ in
    }
    
    
    
    
    alert.addAction(okayAction)
    present(alert, animated: true, completion: nil)
    self.performSegue(withIdentifier: "profile", sender: nil)
}

