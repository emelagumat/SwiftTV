import SwiftUI
import ComposableArchitecture

struct TabBarViewBuilder {
    @ViewBuilder
    func buildView(
        for tab: AppTabRepresentable,
        fromStore store: StoreOf<TabBarFeature>
    ) -> some View {
        switch tab.title {
        case "Series":
            WithViewStore(store, observe: \.tabs) { _ in
                IfLetStore(store.scope(state: \.seriesList, action: TabBarFeature.Action.series)) { store in
                    SeriesListView(store: store)
                }
            }
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
