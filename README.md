# SwiftUINavigationController

블로그: https://velog.io/@quokka/SwiftUI-NavigationView-Coordinator

<img src="/Resource/app.gif" width="30%" height="30%"/>

## 파일구조

![structure.png](/Resource/structure.png)
 
## 코드
- ### Destination.swift
```swift
import Foundation
import SwiftUI

enum Destination {
    case firstView
    case secondView(number: Int)
    case thirdView(number: Int)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .firstView: FirstView()
        case .secondView(let number): SecondView(number: number)
        case .thirdView(let number): ThirdView(number: number)
        }
    }
}
```
- ### Coordinator.swift

```swift
fileprivate extension Notification.Name {
    static let popToRoot = Notification.Name("PopToRoot")
}

final class Coordinator: ObservableObject {
    private var destination: Destination = .firstView
    private let isRoot: Bool
    private var cancellable: Set<AnyCancellable> = []
    @Published private var navigationTrigger = false
    @Published private var rootNavigationTrigger = false
    
    init(isRoot: Bool = false) {
        self.isRoot = isRoot
        
        if isRoot {
           // "PopToRoot" Notification을 구독한다.
           NotificationCenter.default.publisher(for: .popToRoot)
                .sink { [unowned self] _ in
                    rootNavigationTrigger = false
                }
                .store(in: &cancellable)
        }
    }
    
    // getTrigger의 값에 따라 Navigation을 할지 결정하고 isActive의 값이 변경되면 setTrigger함수를 실행한다. 
    @ViewBuilder
    func navigationLinkSection() -> some View {
        NavigationLink(isActive: Binding<Bool>(get: getTrigger, set: setTrigger(newValue:))) {
            destination.view.navigationBarBackButtonHidden()
        } label: {
            EmptyView()
        }
    }
    
    // "popToRoot"이름을 가진 Notification에 알린다.
    func popToRoot() {
        NotificationCenter.default.post(name: .popToRoot, object: nil)
    }
    
    // navigation할 view를 설정해주고, getTrigger의 bool값을 true로 변경해준다.
    func push(destination: Destination) {
        self.destination = destination
        if isRoot {
            rootNavigationTrigger = true
        } else {
            navigationTrigger = true
        }
    }
    
    // NavigationLink의 isActive값은 getTrigger()의 값에 따라 설정됩니다.
    private func getTrigger() -> Bool {
        isRoot ? rootNavigationTrigger : navigationTrigger
    }
    
    // NavigationLink의 isActive값이 변경되면 newValue로 값을 전달해줍니다.
    private func setTrigger(newValue: Bool) {
        if isRoot {
            rootNavigationTrigger = newValue
        } else {
            navigationTrigger = newValue
        }
    }
}
```
- ### SecondView.swift
```swift
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
```

## Reference
https://github.com/urijan44/SwiftUICoordinator.git
