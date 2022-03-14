//
//  Endpoint.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//

import Foundation
import Alamofire

/// enum that has all the endpoint of the apis in the application
/// with the url, method type, parameters and headers for each endpoint
/// converted to urlRequest

enum Endpoint: URLRequestConvertible {
    
    enum Constants {
        static let baseUrl = "https://api.github.com/"
    }
    
    case gists
    case userGists(userName: String)
    
    
    var url : URL {
        switch self {
        
        case .gists:
            return URL(string: Constants.baseUrl + "gists/public")!
            
        case .userGists(let userName):
            return URL(string: Constants.baseUrl + "users/\(userName)/gists")!
        }
    }
    
    var method : HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters : [String:Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    var headers : HTTPHeaders {
        switch self {
        default:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        
        switch method {
        case .get, .delete:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
