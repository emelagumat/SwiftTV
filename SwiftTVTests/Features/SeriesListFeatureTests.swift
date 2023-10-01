import XCTest
import PowerAssert
import ComposableArchitecture

@testable import SwiftTV

final class SeriesListFeatureTests: XCTestCase {
    var state: SeriesListFeature.State!
    var reducer: SeriesListFeature!

    override func setUpWithError() throws {
        state = .init()
        let feature = withDependencies({ $0.listClient = .mock }, operation: {
            SeriesListFeature()
        })

        reducer = feature
    }

    func test_InitialState() throws {
        #assert(!state.collectionStates.isEmpty)
    }

    func test_OnAppear() throws {
        let initialState = state
        _ = reducer.reduce(into: &state, action: .onAppear)
        #assert(initialState == state)
    }
}

extension ListClient {
    static let mock = ListClient(
        getNextPage: {
            .failure(.unknown)
        }
    )
}
