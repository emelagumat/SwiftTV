
import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(store, observe: \.hasLaunched) { viewStore in
            IfLetStore(
                store.scope(
                    state: \.tabBar,
                    action: AppFeature.Action.tabBar
                )
            ) {
                TabBarView(store: $0)
            } else: {
                LoadingView()
            }
            .task {
                store.send(.onAppear)
                await DomainDIContainer().discoverUseCase.getDiscovery()
            }
        }
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: AppFeature.State(), 
            reducer: { AppFeature() }
        )
    )
}
