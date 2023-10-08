import SwiftUI
import ComposableArchitecture

struct MediaSectionView: View {
    let store: StoreOf<MediaSectionFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text(viewStore.collection.title)
                        .font(.large)
                        .fontWeight(.heavy)
                        .padding()
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top, spacing: 8) {
                        ForEachStore(
                            store.scope(
                                state: \.thumbnails,
                                action: MediaSectionFeature.Action.thumbnail(id:action:)
                            ),
                            content: { store in
                                MediaThumbnailView(store: store)
                            }
                        )
                        if !viewStore.thumbnails.isEmpty {
                            ProgressView()
                                .onAppear {
                                    viewStore.send(.onReachListEnd)
                                }
                        }
                    }
                    .padding(.leading)
                }
            }
            .task { viewStore.send(.onAppear) }
        }
    }
}

#Preview {
    MediaSectionView(
        store: .init(
            initialState: MediaSectionFeature.State(),
            reducer: { MediaSectionFeature().dependency(\.context, .preview) }
        )
    )
}
