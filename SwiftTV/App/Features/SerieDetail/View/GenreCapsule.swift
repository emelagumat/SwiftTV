
import SwiftUI




struct GenreCapsule: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(.background)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .lineLimit(1)
            .background(
                Capsule(style: .circular)
                    .foregroundStyle(.primary)
            )
            .fontWidth(.compressed)
            .fontWeight(.ultraLight)
    }
}

#Preview {
    GenreCapsule(text: "Thriller")
}
