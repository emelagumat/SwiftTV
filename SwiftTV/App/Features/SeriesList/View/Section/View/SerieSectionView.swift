
import SwiftUI
import ComposableArchitecture

struct SerieSectionView: View {
    let store: StoreOf<SerieSectionFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text(viewStore.collection.title)
                        .font(.title)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEachStore(
                            store.scope(
                                state: \.thumbnails,
                                action: SerieSectionFeature.Action.thumbnail(id:action:)
                            ),
                            content: {
                                MediaThumbnailView(store: $0)
                            }
                        )
                    }
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
            reducer: { SerieSectionFeature() }
        )
    )
}
