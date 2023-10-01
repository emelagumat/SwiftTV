//

import SwiftUI

struct ListFilterView: View {
    @Binding var isActive: Bool
    let items: [FilterItem]

    var body: some View {
        HStack {
            if isActive {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(items) { item in
                            GenreCapsule(text: item.genre.name)
                        }
                    }
                }
                .animation(.spring(.init(duration: 5, bounce: 20), blendDuration: 1.5), value: isActive)
                .transition(
                    AsymmetricTransition(
                        insertion: .push(from: .leading),
                        removal: .push(from: .trailing)
                    )
                )
            } else {
                Spacer()
            }
            Image(systemName: isActive ? "x.circle" : "slider.horizontal.3")
                .contentTransition(.symbolEffect(.replace))
                .font(.large)
                .animation(.easeInOut, value: isActive)
                .transition(.symbolEffect)
                .onTapGesture {
                    withAnimation {
                        isActive.toggle()
                    }
                }
                .background(.appBackground)
        }
        .padding()
    }
}

#Preview {
    ListFilterView(isActive: .constant(true), items: [])
}
