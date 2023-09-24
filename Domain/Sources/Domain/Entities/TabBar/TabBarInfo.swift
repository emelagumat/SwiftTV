
public struct TabBarInfo: Equatable {
    public let defaultTab: ApplicationTab
    public let items: [ApplicationTab]
    
    public init(defaultTab: ApplicationTab, items: [ApplicationTab]) {
        self.defaultTab = defaultTab
        self.items = items
    }
}
