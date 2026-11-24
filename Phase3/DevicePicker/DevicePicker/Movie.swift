import Foundation

@propertyWrapper
struct DefaultString: Decodable {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(String.self)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: DefaultString.Type, forKey key: Key) throws -> DefaultString {
        (try? decodeIfPresent(type, forKey: key)) ?? DefaultString(wrappedValue: "none")
    }
}

struct Movie: Decodable {
    let title: String
    let releaseDate: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case title
        case releaseDate = "release_date"
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        if let number = try? container.decode(Int.self, forKey: .id) {
            id = String(number)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
    }

}

func loadMovie() async throws -> Movie {
    let key = "79378783cbf028d23490c86d6ae44f4c"
    let address = URL(string: "https://api.themoviedb.org/3/movie/550?api_key=\(key)")!
    let (data, _) = try await URLSession.shared.data(from: address)
    return try JSONDecoder().decode(Movie.self, from: data)
}

struct Post: Decodable {
    let id: Int
    let title: String
    @DefaultString var author: String
}

func loadPosts() async throws -> [Post] {
    let address = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    let (data, _) = try await URLSession.shared.data(from: address)
    return try JSONDecoder().decode([Post].self, from: data)
}
