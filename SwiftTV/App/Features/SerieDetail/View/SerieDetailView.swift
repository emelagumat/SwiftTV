
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
                        .padding()
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .background(.appSurface)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8), style: .circular))
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .background(.appBackground)
            .foregroundStyle(.appText)
            .font(.medium)
        }
    }
    
    private func makeHeader(with viewStore: ViewStoreOf<SerieDetailFeature>) -> some View {
        VStack {
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
                    .font(.large)
                Spacer()
                makeRating(with: viewStore.model.rate)
            }
            .padding(.horizontal)
            if !viewStore.model.genders.isEmpty {
                HStack {
                    Spacer()
                    ForEach(viewStore.model.genders) { gender in
                        GenreCapsule(text: gender.name)
                    }
                }
                .padding([.horizontal])
            }
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
            .foregroundColor(.appAccent)
        }
    }
}

#Preview {
    SerieDetailView(
        store: .init(
            initialState: SerieDetailFeature.State(model: .init(id: "-", name: "Serie", overview: "OverviewwwOverviewwwOverviewwwOverviewwwOverviewwwOverviewww OverviewwwOverviewwwOverviewwwOverviewwwOverviewwwOverviewwwOverviewww OverviewwwOverviewwwOverviewww OverviewwwOverviewww", backdropStringURL: "", posterStringURL: "", genders: [.init(id: 1, name: "Thriller")], rate: .init(popularity: 0, voteAverage: 0, totalVotes: 0))),
            reducer: {
                SerieDetailFeature()
            }
        )
    )
}
