//
//  AppFeature+Action.swift
//  TCAMultiplatform
//
//  Created by Manu Laguna Matías on 22/9/23.
//

import ComposableArchitecture
import Domain

extension AppFeature {
    enum Action: Equatable {
        case onAppear
        case onTabInfoResult(Result<TabBarInfo, DomainError>)
        case tabBar(TabBarFeature.Action)
    }
}
