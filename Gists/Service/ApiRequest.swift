//
//  ApiRequest.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//


import Foundation
import Alamofire
import RxSwift

class ApiRequest {
    
    /// method that calls the API, and returns an observable of the T generic type which is codable (Model)
    /// validates the status code to be 200...300
    
    static func apiCall<T : Decodable>(responseModel: T.Type, request : Endpoint) -> Observable<T> {
        
        /// create the observable of the type T
        return Observable<T>.create { observer -> Disposable in
            
            AF.request(request)
                .validate(statusCode: 200...300)
                .responseData { (response : AFDataResponse<Data>) in
                    
                    
                    guard let statusCode = (response.response?.statusCode) else {
                        observer.onError(NetworkError.serverError)
                        return
                    }
                    switch response.result {
                    
                    case .success(let result):
                        guard !result.isEmpty else {
                            observer.onError(NetworkError.unknownError)
                            return
                        }
                        
                        guard (200...299).contains(statusCode) else {
                            observer.onError(NetworkError.serverError)
                            return
                        }
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: result)
                            observer.onNext(obj)
                            observer.onCompleted()
                        } catch {
                            observer.onError(NetworkError.parsingError)
                            print(error)
                            return
                        }
                        
                    case .failure:
                        observer.onError(NetworkError.unknownError)
                    }
                
            }
            
            return Disposables.create()
        }
        

    }
}
