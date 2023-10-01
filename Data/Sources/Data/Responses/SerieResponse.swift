struct SerieResponse: Codable {
    let backdropPath, firstAirDate: String?
    let genreIDS: [Int]??
    let id: Int?
    let name: String?
    let originCountry: [String?]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct GenresResponse: Codable {
    let genres: [GenreResponse]
}

struct GenreResponse: Codable {
    let id: Int
    let name: String
}
import Domain
extension MediaGenre {
    init(_ response: GenreResponse) {
        self.init(id: response.id, name: response.name)
    }
}
/*
 {
   "genres": [
     {
       "id": 10759,
       "name": "Action & Adventure"
     },
     {
       "id": 16,
       "name": "Animation"
     },
     {
       "id": 35,
       "name": "Comedy"
     },
     {
       "id": 80,
       "name": "Crime"
     },
     {
       "id": 99,
       "name": "Documentary"
     },
     {
       "id": 18,
       "name": "Drama"
     },
     {
       "id": 10751,
       "name": "Family"
     },
     {
       "id": 10762,
       "name": "Kids"
     },
     {
       "id": 9648,
       "name": "Mystery"
     },
     {
       "id": 10763,
       "name": "News"
     },
     {
       "id": 10764,
       "name": "Reality"
     },
     {
       "id": 10765,
       "name": "Sci-Fi & Fantasy"
     },
     {
       "id": 10766,
       "name": "Soap"
     },
     {
       "id": 10767,
       "name": "Talk"
     },
     {
       "id": 10768,
       "name": "War & Politics"
     },
     {
       "id": 37,
       "name": "Western"
     }
   ]
 }
 */
