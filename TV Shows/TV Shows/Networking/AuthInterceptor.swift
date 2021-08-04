//
//  AuthInterceptor.swift
//  TV Shows
//
//  Created by Infinum on 01.08.2021..
//

import Alamofire

class AuthInterceptor : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var updatedRequest = urlRequest
        if let authInfo = AuthStorage.shared.authInfo {
            authInfo.headers.forEach {
                updatedRequest.addValue($1, forHTTPHeaderField: $0)
            }
        }
        completion(.success(updatedRequest))
    }
}
