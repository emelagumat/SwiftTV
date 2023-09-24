//
//  AppFeature.swift
//  TCAMultiplatform
//
//  Created by Manu Laguna Matías on 22/9/23.
//

import ComposableArchitecture
import Domain

struct AppFeature: Reducer {
    let container: DomainDIContainer
    
    init(container: DomainDIContainer = .init()) {
        self.container = container
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tabBar:
                return .none
            case .onAppear:
                return .run { send in
                    let tabInfoResult = await container.tabBarUseCase.getTabInfo()
                    await send(.onTabInfoResult(tabInfoResult))
                }
            case let .onTabInfoResult(result):
                state.updateWithResult(
                    result,
                    mapper: TabBarFeature.State.init,
                    keyPath: \.tabBar
                )
                return .none
            }
        }
        .ifLet(\.tabBar, action: /Action.tabBar) {
            TabBarFeature(container: container)
        }
    }
}

private extension TabBarFeature.State {
    init(_ info: TabBarInfo) {
        self.init(
            selectedTab: .init(info.defaultTab),
            tabs: info.items.map(AppTabRepresentable.init)
        )
    }
}

extension AppTabRepresentable {
    init(_ tab: ApplicationTab) {
        self.init(
            id: tab.id,
            title: .init(tab.name),
            symbolName: tab.symbolName
        )
    }
}
