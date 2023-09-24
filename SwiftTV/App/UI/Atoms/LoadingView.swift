
import SwiftUI

struct LoadingView: View {
    var body: some View {
        Image(systemName: "timelapse")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolRenderingMode(.hierarchical)
            .symbolEffect(.variableColor)
            .foregroundStyle(.primary)
            .padding()
    }
}

#Preview {
    LoadingView()
}
