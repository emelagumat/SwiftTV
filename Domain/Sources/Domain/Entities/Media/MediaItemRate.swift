public struct MediaItemRate: Equatable {
    public let popularity: Double
    public let voteAverage: Double
    public let totalVotes: Int

    public init(
        popularity: Double,
        voteAverage: Double,
        totalVotes: Int
    ) {
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.totalVotes = totalVotes
    }
}
