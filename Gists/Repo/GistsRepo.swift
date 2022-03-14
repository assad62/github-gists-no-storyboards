//
//  GistsRepo.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//

import Foundation
import RxSwift

/// create protocol to be able to inject this in the view model, and also will be helpful when you integrate unit tests to mock this repo class
protocol GistsRepoProtocol {
    func getGists() -> Observable<GistsModel>
}


class GistsRepo: GistsRepoProtocol {
    
    func getGists() -> Observable<GistsModel> {
        return ApiRequest.apiCall(responseModel: GistsModel.self, request: .gists)
    }
    
    
}
