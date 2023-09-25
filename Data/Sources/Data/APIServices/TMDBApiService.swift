
import APIClient

public protocol TMDBApiService: APIService {}

public extension TMDBApiService {
    var baseStringURL: String {
        "https://api.themoviedb.org/3"
    }
}
