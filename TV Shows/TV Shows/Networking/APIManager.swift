//
//  APIManager.swift
//  TV Shows
//
//  Created by Infinum on 01.08.2021..
//

import Alamofire

class APIManager {
    
    static let shared: APIManager = .init()
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let session = Session(
            configuration: configuration,
            interceptor: AuthInterceptor()
        )
        return session
    }()
    
    private init() {}
}

extension APIManager {
    func call<Model: Decodable> (
        of type: Model.Type,
        router: URLRequestConvertible,
        responseHandler: ((DataResponse<Model, AFError>) -> Void)? = nil,
        completion: @escaping (Result<Model, AFError>) -> Void
    ) {
        session
            .request(router)
            .validate()
            .responseDecodable(of: Model.self) { dataResponse in
                responseHandler?(dataResponse)
                completion(dataResponse.result)
            }
    }
}
