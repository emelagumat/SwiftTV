
import XCTest
import PowerAssert

@testable import SwiftTV

final class SeriesListFeatureTests: XCTestCase {
    var state: SeriesListFeature.State!
    var reducer: SeriesListFeature!
    
    
    override func setUpWithError() throws {
        state = .init()
        reducer = .init(container: .mock)
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
