//
//  GistDetailsRepo.swift
//  Gists
//
//  Created by Mohammad Assad on 12/03/2022.
//

import Foundation
import RxSwift


/// create protocol to be able to inject this in the view model, and also will be helpful when you integrate unit tests to mock this repo class
protocol GistDetailsRepoProtocol {
    func getUserGists() -> Observable<GistsModel>
}

class GistDetailsRepo: GistDetailsRepoProtocol {
    
    private var userName: String
    
    init(userName: String) {
        self.userName = userName
    }
    
    func getUserGists() -> Observable<GistsModel> {
        return ApiRequest.apiCall(responseModel: GistsModel.self, request: .userGists(userName: userName))
    }
    
    
}
