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
                .frame(height: 180)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
            }
            .task { viewStore.send(.onAppear) }
        }
    }
}


#Preview("List") {
    SerieSectionView(
        store: .init(
            initialState: SerieSectionFeature.State(),
            reducer: { SerieSectionFeature() }
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

extension SerieModel {
    static let mock = SerieModel(
        id: "-",
        name: "Lost",
        backdropStringURL: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        posterStringURL: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"
    )
}
