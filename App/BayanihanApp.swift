import SwiftUI

@main
@MainActor
struct BayanihanApp: App {

    // BayanihanController now owns the SwiftData-backed BayanihanDataStore
    // internally (see Controllers/BayanihanController.swift). The App still
    // just holds the one Controller instance via @State, unchanged from
    // before — it does not create a ModelContainer, ModelContext, or a
    // second BayanihanDataStore itself. The explicit @MainActor above makes
    // this type's isolation match the now-@MainActor Controller explicitly,
    // rather than relying on inferred isolation from the App conformance.
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