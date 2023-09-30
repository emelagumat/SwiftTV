
import ComposableArchitecture
import SwiftUI
import MLDFeatures

struct SerieDetailView: View {
    let store: StoreOf<SerieDetailFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            VStack {
                makeHeader(with: viewStore)
                Spacer()
                    .frame(height: 32)
                ScrollView {
                    Text(viewStore.model.overview)
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private func makeHeader(with viewStore: ViewStoreOf<SerieDetailFeature>) -> some View {
        VStack(alignment: .leading) {
            RemoteImage(
                store: .init(
                    initialState: RemoteImageFeature.State(imageStringURL: viewStore.model.backdropStringURL),
                    reducer: { 
                        RemoteImageFeature()
                    }
                )
            )
            .resizable()
            HStack {
                Text(viewStore.model.name)
                    .font(.title2)
                Spacer()
                makeRating(with: viewStore.model.rate)
            }
            .padding()
        }
    }
    
    private func makeRating(with rate: RateModel) -> some View {
        let stars = rate.voteAverage / 10 * 5
        
        return VStack {
            HStack {
                ForEach(1...5, id: \.self) { index in
                    switch Double(index) {
                    case (0...stars):
                        Image(systemName: "star.fill")
                    case let double where (0..<(stars + 0.51)).contains(double):
                        Image(systemName: "star.leadinghalf.filled")
                    default:
                        Image(systemName: "star")
                    }
                }
            }
            .foregroundColor(.accentColor)
        }
    }
}

#Preview {
    SerieDetailView(
        store: .init(
            initialState: SerieDetailFeature.State(model: .mockPreview), reducer: {
                SerieDetailFeature()
            }))
}
extension Namespace {
    static var mock: Namespace {
        .init()
    }
    
    static var mockId: Namespace.ID {
        Namespace.mock.wrappedValue
    }
}

extension SerieModel {
    static var mockPreview: SerieModel {
        .init(
            id: UUID().uuidString,
            name: "Tagesschau",
            overview: "$0.overview",
            backdropStringURL: "https://image.tmdb.org/t/p/w500/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg",
            posterStringURL: "https://image.tmdb.org/t/p/w500/60cqjI590JKXCAABqCStVmSBGET.jpg",
            rate: .init(popularity: 1000, voteAverage: 6.9, totalVotes: 270)
        )
    }
}
