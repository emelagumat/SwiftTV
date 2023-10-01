import SwiftUI
import ComposableArchitecture

struct SerieSectionView: View {
    let store: StoreOf<SerieSectionFeature>

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
                                action: SerieSectionFeature.Action.thumbnail(id:action:)
                            ),
                            content: { store in
                                MediaThumbnailView(store: store)
                                    .transition(.opacity)
                            }
                        )

                        ProgressView()
                            .onAppear { viewStore.send(.onReachListEnd) }
                    }
                    .padding(.leading)
                }
            }
            .task { viewStore.send(.onAppear) }
        }
    }
}

#Preview {
    SerieSectionView(
        store: .init(
            initialState: SerieSectionFeature.State(),
            reducer: { SerieSectionFeature().dependency(\.context, .preview) }
        )
    )
}
