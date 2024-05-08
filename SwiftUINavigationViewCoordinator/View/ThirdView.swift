import SwiftUI

struct ThirdView: View {
    @StateObject private var coordinator = Coordinator(isRoot: false)
    @Environment(\.presentationMode) private var presentationMode
    let number: Int
    
    var body: some View {
        VStack {
            coordinator.navigationLinkSection()
            Text("\(number)")
                .font(.title)
            Spacer()
            HStack(spacing: 50) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Back to 2")
                })
                Button(action: {
                    coordinator.popToRoot()
                }, label: {
                    Text("Back to Root")
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}

#Preview {
    ThirdView(number: 3)
}
