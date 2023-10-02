//
//  TabBarFeature.swift
//  Remember
//
//  Created by Manu Laguna Matías on 22/9/23.
//

import ComposableArchitecture
import SwiftUI

struct TabBarFeature: Reducer {
    let container: DomainDIContainer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onSelect(tab):
                state.selectedTab = tab
                return .none
            case .onAppear:
                return .none
            case .series:
                return .none
            }
        }
        .ifLet(\.seriesList, action: /Action.series) {
            SeriesListFeature()
        }
    }
}

struct AppTabRepresentable: Identifiable, Hashable, Equatable {
    let id: String
    let title: LocalizedStringKey
    let symbolName: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TabBarFeature {
    struct State: Equatable {
        var selectedTab: AppTabRepresentable
        var tabs: [AppTabRepresentable]

        var seriesList: SeriesListFeature.State? = .init()
    }

    enum Action: Equatable {
        case onAppear
        case onSelect(AppTabRepresentable)
        case series(SeriesListFeature.Action)
    }
}
