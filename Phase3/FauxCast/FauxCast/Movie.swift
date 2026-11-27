import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?

    var posterURL: URL? { TMDB.imageURL(posterPath) }
    var backdropURL: URL? { TMDB.imageURL(backdropPath, size: "w780") }
}

struct MovieList: Decodable {
    let results: [Movie]
}

enum TMDB {
    static func imageURL(_ path: String?, size: String = "w500") -> URL? {
        guard let path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size)\(path)")
    }

    static func trending() async throws -> [Movie] {
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(Secrets.tmdbKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(MovieList.self, from: data).results
    }
}