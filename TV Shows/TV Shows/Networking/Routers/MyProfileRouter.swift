import Foundation
import Alamofire

extension Router {

    enum MyProfile {

        static func getInfo() -> Router {
            return Router(
                path: "/users/me",
                method: .get,
                params: [:]
            )
        }
    }
}
