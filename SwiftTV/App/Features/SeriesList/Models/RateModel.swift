import Domain
import ComposableArchitecture

struct RateModel: Equatable {
    let images: [RateIconRepresentable]
    let totalVotes: Int
}

struct RateIconRepresentable: Identifiable, Equatable {
    let id: Int
    let imageName: String
}

extension RateModel {
    init(_ rate: MediaItem.Rate) {
        let icons = Self.makeRatingImages(with: rate).enumerated()
            .map { index, imageName in
                RateIconRepresentable(
                    id: index,
                    imageName: imageName
                )
            }

        self.init(
            images: icons,
            totalVotes: rate.totalVotes
        )
    }

    private static func makeRatingImages(with rate: MediaItem.Rate) -> [String] {
        let rateBase: Double = 10
        let totalStars: Double = 5
        let stars = rate.voteAverage / rateBase * totalStars

        return (1...5).map { index in
            switch Double(index) {
            case (0...stars):
                "star.fill"
            case let double where (0..<(stars + 0.51)).contains(double):
                "star.leadinghalf.filled"
            default:
                "star"
            }
        }
    }
}
