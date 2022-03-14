//
//  String+Extension.swift
//  Gists
//
//  Created by Mohammad Assad on 12/03/2022.
//

import UIKit

extension String {
    
    /// getting the height of a string with known UILabel width and font
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }
}
