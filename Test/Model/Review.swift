/// Модель отзыва.
struct Review: Decodable {
    private enum CodingKeys: String, CodingKey {
        case avatar_url
        case photos
        case first_name
        case last_name
        case rating
        case text
        case created
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try container.decode(String.self, forKey: .avatar_url)
        photos = try container.decode([String].self, forKey: .photos)
        firstName = try container.decode(String.self, forKey: .first_name)
        lastName = try container.decode(String.self, forKey: .last_name)
        rating = try container.decode(Int.self, forKey: .rating)
        text = try container.decode(String.self, forKey: .text)
        created = try container.decode(String.self, forKey: .created)
    }
    /// URL аватарки пользователя.
    let avatarUrl: String
    /// Фото в отзыве.
    let photos: [String]
    /// Имя пользователя.
    let firstName: String
    /// Фамилия пользователя.
    let lastName: String
    /// Рейтинг отзыва.
    let rating: Int
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
