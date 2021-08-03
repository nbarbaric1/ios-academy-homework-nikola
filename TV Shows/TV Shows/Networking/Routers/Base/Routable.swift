//
//  Routable.swift
//  TV Shows
//
//  Created by Infinum on 01.08.2021..
//

import Foundation
import Alamofire

public protocol Routable : URLRequestConvertible {
    
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var params: Parameters? { get }
}

public extension Routable {
    
    func asURLRequest() throws -> URLRequest {
        let url = try pathUrl()
        var request = try URLRequest(url: url, method: method, headers: headers)
        
        switch method {
        case .post, .get, .patch:
            // changed JSONEncoding to URLEncoding
            request = try URLEncoding.default.encode(request, with: params)
        default:
            request = try URLEncoding.default.encode(request, with: params)
        }
        return request
    }
}

private extension Routable {
    func pathUrl() throws -> URL {
        if path.starts(with: "http") {
            return try path.asURL()
        }
        return try baseUrl.asURL().appendingPathComponent(path)
    }
}
