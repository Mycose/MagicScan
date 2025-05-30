//
//  MagicScanApp.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import SwiftUI

@main
struct MagicScanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
