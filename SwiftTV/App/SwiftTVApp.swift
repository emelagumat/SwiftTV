//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct SwiftTVApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: .init(),
                    reducer: { AppFeature() }
                )
            )
        }
        .modelContainer(sharedModelContainer)
        .environment(\.font, .custom("Futura-Medium", size: 12))
    }
}
