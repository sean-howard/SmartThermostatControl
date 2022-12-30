//
//  ThermometerSummaryView.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 21/12/2022.
//

import SwiftUI

struct ThermometerSummaryView: View {
    var status: Status
    var showStatus: Bool
    var temperature: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Text(TemperatureFormatter.formatted(celcius: temperature))
                .font(.system(size: 48))
                .foregroundColor(.white)
            
            if showStatus {
                Text(status.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(showStatus ? 0.6 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showStatus)
            }
        }
        .animation(.easeOut(duration: 1), value: showStatus)
    }
}

struct ThermometerSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerSummaryView(
            status: .heating,
            showStatus: true,
            temperature: 22
        )
        .background(Color("Inner Dial 2"))
    }
}
