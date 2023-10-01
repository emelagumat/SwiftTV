
import ComposableArchitecture

extension SerieModel {
    enum Key: DependencyKey {
        static var liveValue = SerieModel.empty
        static var previewValue: SerieModel = .init(
            id: "1396",
            name: "Breaking Bad",
            overview: .breakingBadOverview,
            backdropStringURL: "https://image.tmdb.org/t/p/w500/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg", posterStringURL: "https://image.tmdb.org/t/p/w500/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg", genders: [],
            rate: .init(popularity: 240.31, voteAverage: 8.9, totalVotes: 12380))
    }
}

extension SerieModel {
    static let empty = SerieModel(
        id: "",
        name: "",
        overview: "",
        backdropStringURL: "",
        posterStringURL: "", 
        genders: [],
        rate: .init(popularity: .zero, voteAverage: .zero, totalVotes: .zero)
    )
}

extension DependencyValues {
    var selectedSerie: SerieModel {
        get { self[SerieModel.Key.self] }
        set { self[SerieModel.Key.self] = newValue }
    }
}

private extension String {
    static var breakingBadOverview: String {
        "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime."
    }
}
/*
 "id": 1396,
       "name": "Breaking Bad",
       "origin_country": [
         "US"
       ],
       "original_language": "en",
       "original_name": "Breaking Bad",
       "overview": "When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
       "popularity": 240.31,
       "poster_path": "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg",
       "vote_average": 8.9,
       "vote_count": 12380
     },
     {
       "ba
 */
