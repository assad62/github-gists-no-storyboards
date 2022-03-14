//
//  UIImageView+Extension.swift
//  Gists
//
//  Created by Mohammad Assad on 12/03/2022.
//

import UIKit


extension UIImageView {
    
    func downloadFromURL(_ urlString: String) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: urlString),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async { self?.image = image }
            } else {
                DispatchQueue.main.async { self?.image = UIImage(named: "user") }
            }
        }
    }
    
    
}
