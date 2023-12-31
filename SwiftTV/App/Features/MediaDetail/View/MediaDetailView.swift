import ComposableArchitecture
import SwiftUI
import MLDFeatures

struct MediaDetailView: View {
    let store: StoreOf<MediaDetailFeature>

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
            .navigationTitle(viewStore.model.name)
            .background(.appBackground)
            .foregroundStyle(.appText)
            .font(.medium)
        }
    }

    private func makeHeader(with viewStore: ViewStoreOf<MediaDetailFeature>) -> some View {
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
                if !viewStore.model.genres.isEmpty {
                    HStack {
                        Spacer()
                        ForEach(viewStore.model.genres) { genre in
                            GenreCapsule(text: genre.name)
                        }
                    }
                    .padding([.horizontal])
                }

        }
    }

    private func makeRating(with rate: RateModel) -> some View {
        VStack {
            HStack {
                ForEach(rate.images) { representable in
                    Image(systemName: representable.imageName)
                }
            }
            .foregroundColor(.appAccent)
        }
    }
}

#Preview {
    MediaDetailView(store: .init(MediaDetailFeature()))
}
