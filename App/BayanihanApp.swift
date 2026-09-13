import SwiftUI

@main
struct BayanihanApp: App {
    
    @State private var controller = BayanihanController()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
            }
            .environment(controller)
        }
    }
}