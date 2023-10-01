//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct SwiftTVApp: App {
    
    init() {
        setupAppearance()
        
    }
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: .init(),
                    reducer: { AppFeature() }
                )
            )
            .tint(.appAccent)
            .foregroundStyle(Color.appText)
            
        }
        .environment(\.font, .medium)
    }
}

private extension SwiftTVApp {
    func setupAppearance() {
        UITabBar.appearance().unselectedItemTintColor = .appDisabled
        
        
        let fontAtributes = [NSAttributedString.Key.font: UIFont.init(name: "Futura-Medium", size: 12)!]
        UITabBarItem.appearance()
            .setTitleTextAttributes(fontAtributes, for: .normal)
    }
}
