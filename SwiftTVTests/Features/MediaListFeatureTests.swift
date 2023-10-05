import XCTest
import PowerAssert
import ComposableArchitecture

@testable import SwiftTV

final class MediaListFeatureTests: XCTestCase {
    var state: MediaListFeature.State!
    var reducer: MediaListFeature!

    override func setUpWithError() throws {
        state = .init()
        let feature = withDependencies({ $0.listClient = .mock }, operation: {
            MediaListFeature()
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
        getNextPage: { _ in
            .failure(.unknown)
        },
        getAllGenres: { .failure(.unknown)}
    )
}
