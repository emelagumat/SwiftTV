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
            case .series, .movies:
                return .none
            }
        }
        .ifLet(\.seriesList, action: /Action.series) {
            SeriesListFeature()
                ._printChanges()
        }
        .ifLet(\.moviesList, action: /Action.movies) {
            SeriesListFeature()
                .dependency(\.listClient, ListClientKey.movies)
                ._printChanges()
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
        var moviesList: SeriesListFeature.State? = .init(type: .movies)
    }

    enum Action: Equatable {
        case onAppear
        case onSelect(AppTabRepresentable)
        case series(SeriesListFeature.Action)
        case movies(SeriesListFeature.Action)
    }
}
