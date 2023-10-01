
import Domain

struct RateModel: Equatable {
    let popularity: Double
    let voteAverage: Double
    let totalVotes: Int
}

extension RateModel {
    init(_ rate: MediaItem.Rate) {
        self.init(
            popularity: rate.popularity,
            voteAverage: rate.voteAverage,
            totalVotes: rate.totalVotes
        )
    }
}
