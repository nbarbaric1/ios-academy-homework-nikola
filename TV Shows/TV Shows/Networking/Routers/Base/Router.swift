import Foundation
import Alamofire

open class Router: Routable {

    open var baseUrl: String
    open var path: String
    open var method: HTTPMethod
    open var headers: HTTPHeaders?
    open var params: Parameters?

    public init(
        baseUrl: String,
        path: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        params: Parameters?
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.params = params
    }
}

public extension Router {

    convenience init(
        path: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        params: Parameters? = nil
    ) {
        self.init(
            baseUrl: Constants.API.baseUrl,
            path: path,
            method: method,
            headers: headers,
            params: params
        )
    }
}
