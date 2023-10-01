import APIClient
import Foundation

public class TMDBProvider: APIProvider {
    private let authToken: String

    public init(authToken: String) {
        self.authToken = authToken
    }

    public override func buildRequest(from endpoint: Endpoint) -> URLRequest {
        var request = super.buildRequest(from: endpoint)

        var headers = request.allHTTPHeaderFields ?? [:]
        headers["accept"] = "application/json"
        headers["Authorization"] = "Bearer \(authToken)"
        request.allHTTPHeaderFields = headers

        return request
    }
}
