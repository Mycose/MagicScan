//
//  MainView.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
            
            LibraryView()
                .tabItem {
                    Label("Librarie", systemImage: "book.pages.fill")
                }
        }
        
    }
}

#Preview {
    MainView()
}
