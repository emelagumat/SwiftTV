//
//  TabBarView.swift
//  Remember
//
//  Created by Manu Laguna Matías on 22/9/23.
//

import ComposableArchitecture

import SwiftUI

struct TabBarView: View {
    let store: StoreOf<TabBarFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            VStack {
                TabView(
                    selection: viewStore.binding(
                        get: { $0.selectedTab },
                        send: { tab in
                            withAnimation { .onSelect(tab) }
                        }
                    ),
                    content: {
                        ForEach(viewStore.tabs) {
                            buildTab(with: $0)
                        }
                    }
                )
            }
            
        }
    }
    
    private func buildTab(with representable: AppTabRepresentable) -> some View {
        Text(representable.title)
            .tabItem {
                Label(
                    title: { Text(representable.title) },
                    icon: {
                        Image(systemName: representable.symbolName)
                    }
                )
                
            }
            .tag(representable)
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

extension TabBarFeature.State {
    static let previews: TabBarFeature.State = {
        let tab = AppTabRepresentable(
            id: "0",
            title: "Tab",
            symbolName: "circle"
        )
        
        return .init(
            selectedTab: tab, tabs: [tab]
        )
    }()
}
