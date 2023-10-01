
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
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
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
                    .font(.title2)
                Spacer()
                makeRating(with: viewStore.model.rate)
            }
            .padding(.horizontal)
            HStack {
                Spacer()
                ForEach(viewStore.model.genders) { gender in
                    GenderCapsule(text: gender.name)
                }
            }
            .padding([.horizontal, .bottom])
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

struct GenderCapsule: View {
    let text: String
//    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .foregroundStyle(.background)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .lineLimit(1)
            .background(
                Capsule(style: .circular)
                    .foregroundStyle(.primary)
            )
    }
}

#Preview {
    SerieDetailView(
        store: .init(
            initialState: SerieDetailFeature.State(),
            reducer: {
                SerieDetailFeature()
            }
        )
    )
}
