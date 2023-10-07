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
            MediaListFeature()
        }
        .ifLet(\.moviesList, action: /Action.movies) {
            MediaListFeature()
                .dependency(\.listClient, ListClientKey.movies)
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

        var seriesList: MediaListFeature.State? = .init()
        var moviesList: MediaListFeature.State? = .init(type: .movies)
    }

    enum Action: Equatable {
        case onAppear
        case onSelect(AppTabRepresentable)
        case series(MediaListFeature.Action)
        case movies(MediaListFeature.Action)
    }
}
