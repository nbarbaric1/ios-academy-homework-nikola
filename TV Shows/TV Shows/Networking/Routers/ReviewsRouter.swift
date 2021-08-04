import Foundation

extension Router {
    
    enum Review {
        
        static func getReviews(page: Int = 1, pageSize: Int = 100, id: String) -> Router {
            
            return Router(
                path: "/shows/" + id + "/reviews",
                method: .get,
                params: [
                    "page": page,
                    "items": pageSize
                ])
        }
        
        static func addReview(rating: String, comment: String, id: String) -> Router {
            
            return Router(
                path: "/reviews",
                method: .post,
                params: [
                    "rating": rating,
                    "comment": comment,
                    "show_id": id
                ])
        }
    }
}
