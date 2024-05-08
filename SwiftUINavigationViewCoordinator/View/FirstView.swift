import SwiftUI

struct FirstView: View {
    @StateObject private var coordinator: Coordinator = Coordinator(isRoot: true)
    let number: Int = 1
    
    var body: some View {
        VStack {
            coordinator.navigationLinkSection()
            Text("\(number)")
                .font(.title)
            Spacer()
            HStack {
                Button(action: {
                    coordinator.push(destination: .secondView(number: 2))
                }, label: {
                    Text("Move to 2")
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.pink)
    }
}

#Preview {
    FirstView()
}
