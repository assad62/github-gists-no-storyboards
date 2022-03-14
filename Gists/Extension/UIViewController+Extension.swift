//
//  UIViewController+Extension.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Gists", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}


