
import SwiftUI
import ComposableArchitecture

struct SeriesListView: View {
    let store: StoreOf<SeriesListFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: SeriesListView.State.init
        ) { viewStore in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(viewStore.sections) { section in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(section.title)
                                Spacer()
                            }
                        }
                    }
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    SeriesListView(store: .init(initialState: .init(), reducer: SeriesListFeature.init))
}
