import SwiftUI

struct SecondView: View {
    @StateObject private var coordinator: Coordinator = Coordinator(isRoot: false)
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
                    Text("Back to 1")
                })
                Button(action: {
                    coordinator.push(destination: .thirdView(number: 3))
                }, label: {
                    Text("Move to 3")
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.green)
    }
}

#Preview {
    SecondView(number: 2)
}

