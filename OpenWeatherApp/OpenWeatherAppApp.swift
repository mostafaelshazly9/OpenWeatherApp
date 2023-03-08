//
//  OpenWeatherAppApp.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import SwiftUI

@main
struct OpenWeatherAppApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DashboardView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
