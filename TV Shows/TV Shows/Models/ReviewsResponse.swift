import Foundation

struct ReviewsResponse: Decodable {
    let reviews: [Review]
    let meta: Meta
}

struct Review: Decodable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}
