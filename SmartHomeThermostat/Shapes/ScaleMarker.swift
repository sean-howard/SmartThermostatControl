//
//  ScaleMarker.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 30/12/2022.
//

import SwiftUI

struct ScaleMarker: View {
    
    @Binding var fillColor: Color
    
    var body: some View {
        Trapezoid(percent: 10)
            .fill(fillColor)
            .frame(width: 6, height: 22)
            .rotationEffect(.degrees(180))
            .cornerRadius(20)
            .animation(.linear(duration: 1), value: fillColor)
    }
}
