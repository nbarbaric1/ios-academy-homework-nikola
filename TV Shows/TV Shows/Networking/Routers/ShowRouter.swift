import Foundation

extension Router {

    enum Show {

        static func shows(page: Int = 1, pageSize: Int = 100) -> Router {
            return Router(
                path: "/shows",
                method: .get,
                params: [
                    "page": page,
                    "items": pageSize
                ]
            )
        }
    }
}
