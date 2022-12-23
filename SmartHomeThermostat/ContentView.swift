//
//  ContentView.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 21/12/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    
                    ThermometerView()
                        .padding(.top, 30)
                        .padding(.bottom, 60)
                    
                    HStack(spacing: 20) {
                        ClimateCard(
                            iconName: "humidity.fill",
                            index: "Inside humidity",
                            measure: "49%"
                        )
                        
                        ClimateCard(
                            iconName: "thermometer",
                            index: "Outside temp.",
                            measure: "-10°"
                        )
                    }
                }
            }
            .navigationTitle("Thermostat")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
