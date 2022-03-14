//
//  NetworkError.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//

import Foundation


/// Custom error with a description, feel free to put the error cases you want :)

enum NetworkError : Error {
    
    case unknownError
    case serverError
    case parsingError
    
    var errorDescription : String {
        switch self {
        case .parsingError : return "Invalid Response Data"
        case .unknownError : return "Something went wrong!"
        case .serverError : return "Server Error, Invalid request"
        }
    }
}
