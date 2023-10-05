//

import SwiftUI
import ComposableArchitecture
import MLDFeatures

struct MediaThumbnailView: View {
    let store: StoreOf<MediaThumnailFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                RemoteImage(
                    store: store.scope(
                        state: \.image,
                        action: MediaThumnailFeature.Action.image
                    )
                )
                .resizable()
                .foregroundStyle(.appDisabled)
                .task { viewStore.send(.onAppear) }
                .frame(height: 180)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .onTapGesture { viewStore.send(.onTap) }
            }
        }
    }
}

#Preview("List") {
    MediaSectionView(
        store: .init(
            initialState: MediaSectionFeature.State(),
            reducer: { MediaSectionFeature() }
        )
    )
}
#Preview("Thumbnail") {
    MediaThumbnailView(
        store: .init(
            initialState: MediaThumnailFeature.State(item: .mock),
            reducer: { MediaThumnailFeature() }
        )
    )
}

extension MediaItemModel {
    static let mock = MediaItemModel(
        id: "-",
        name: "Lost",
        overview: "$0.overview",
        backdropStringURL: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        posterStringURL: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        genres: [],
        rate: .init(images: [], totalVotes: .zero)
    )
}
