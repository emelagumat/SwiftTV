import SwiftUI
import ComposableArchitecture

struct TabBarViewBuilder {
    @ViewBuilder
    func buildView(
        for tab: AppTabRepresentable,
        fromStore store: StoreOf<TabBarFeature>
    ) -> some View {
        switch tab.title {
        case "TV":
            NavigationStack {
                WithViewStore(store, observe: \.tabs) { _ in
                    IfLetStore(store.scope(state: \.seriesList, action: TabBarFeature.Action.series)) { store in
                        
                        MediaListView(store: store)
                            .navigationTitle("TV")
#if canImport(iOS)
                            .navigationBarTitleDisplayMode(.inline)
#endif
                    }
                    
                }
            }
        case "Movies":
            NavigationStack {
                WithViewStore(store, observe: \.tabs) { _ in
                    IfLetStore(store.scope(state: \.moviesList, action: TabBarFeature.Action.movies)) { store in
                        MediaListView(store: store)
                            .navigationTitle("Movies")
#if canImport(iOS)
                            .navigationBarTitleDisplayMode(.inline)
#endif
                    }
                }
            }
        case "App":
            ZStack(alignment: .center) {
                VStack(spacing: 32) {
                    Text("Powered by:")
                        .font(.extraLarge)
                    Image(.tmdbLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                    Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                        .font(.small)
                        .fontWeight(.light)
                        .transition(.scale)
                        .animation(.bouncy, value: true)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        default:
            WithViewStore(store, observe: { $0 }) { _ in
                ZStack(alignment: .center) {
                    Text("WIP")
                        .font(.extraLarge)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        }
    }
}
