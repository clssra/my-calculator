//
//  my_calculatorApp.swift
//  my calculator
//
//  Created by clssra on 22/10/21.
//

import SwiftUI

@main
struct my_calculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GlobalEnviroment())
        }
    }
}
