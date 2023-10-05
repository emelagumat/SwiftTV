//

import SwiftUI
import ComposableArchitecture

struct ListFilterView: View {
    let store: StoreOf<ListFilterFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0} ) { viewStore in
            HStack {
                if viewStore.isActive {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewStore.items) { item in
                                GenreCapsule(text: item.genre.name)
                            }
                        }
                    }
                    .animation(.spring(.bouncy), value: viewStore.isActive)
                    .transition(
                        AsymmetricTransition(
                            insertion: .push(from: .leading),
                            removal: .push(from: .trailing)
                        )
                    )
                } else {
                    Spacer()
                        .frame(height: .zero)
                }
            }
            .padding()
            .toolbar {
                Button(
                    action: {
                        viewStore.send(.onActivateButtonTapped)
//                        withAnimation {
//                            isActive.toggle()
//                        }
                    },
                    label: {
                        Image(systemName: viewStore.isActive ? "x.circle" : "slider.horizontal.3")
                            .contentTransition(.symbolEffect(.replace))
                            .font(.large)
                            .animation(.easeInOut, value: viewStore.isActive)
                            .transition(.symbolEffect)
                    }
                )
            }
        }
    }
}

//#Preview {
//    ListFilterView(
//        isActive: .constant(true),
//        items: [
//            .init(genre: .init(id: 0, name: "Thriller"), isSelected: false),
//            .init(genre: .init(id: 1, name: "Terror"), isSelected: false)
//        ]
//    )
//}
