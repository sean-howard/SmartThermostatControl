//
//  ThermometerView.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 21/12/2022.
//

import SwiftUI

enum Status: String {
    case heating = "HEATING"
    case cooling = "COOLING"
    case reaching = "REACHING"
}

struct ThermometerView: View {
    
    private let config = ThermostatConfiguration.standard
    private let temperatureChangeIncrement: CGFloat = 1
    
    @State private var currentTemperature: CGFloat = 0
    @State private var targetDegreesAngle: CGFloat = 36
    @State private var showStatus = false
        
    var targetTemperature: CGFloat {
        let denominator: CGFloat = 1 / temperatureChangeIncrement
        let result: CGFloat = min(max(targetDegreesAngle / 360 * config.markersOnCircumference, config.temperature.minimum), config.temperature.maximum)
        let rounded = round(denominator * result) / denominator
        return rounded
    }
    
    // To eventually be polled from an external data source
    var currentDegreesAngle: CGFloat {
        return currentTemperature / config.markersOnCircumference * 360
    }
    
    var status: Status {
        if currentTemperature < targetTemperature {
            return .heating
        } else if currentTemperature > targetTemperature {
            return .cooling
        } else {
            return .reaching
        }
    }
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                // MARK: Thermometer Scale
                ThermometerScaleView(
                    currentDegrees: currentDegreesAngle,
                    targetDegrees: targetDegreesAngle
                )
                
                ThermometerSummaryView(
                    status: status,
                    showStatus: showStatus,
                    temperature: currentTemperature
                )
            }
            controls
            targetTemperatureSummary
        }
        .onAppear {
            currentTemperature = 22
            targetDegreesAngle = currentTemperature / config.markersOnCircumference * 360
        }
        .onReceive(timer) { _ in
            updateCurrentTemperature()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
    /// For the sake of mocking, each time the timer triggers we increment the `currentTemperature` until it's reached the `targetTemperature`.
    /// In reality I aspect `currentTemperature` to set from an external data source like API polling.
    ///
    /// `status` is computed property updated based on `>` and `<` operators.
    private func updateCurrentTemperature() {
        switch status {
            case .heating:
                showStatus = true
                currentTemperature += temperatureChangeIncrement
            case .cooling:
                showStatus = true
                currentTemperature -= temperatureChangeIncrement
            case .reaching:
                showStatus = false
                break
        }
    }
}



struct ThermometerView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}

extension ThermometerView {
    private func calculateAngle(centerPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        let radians = atan2(endPoint.x - centerPoint.x, centerPoint.y - endPoint.y)
        let degrees = 180 + (radians * 180 / .pi)
        return degrees
    }
}

extension ThermometerView {
    private var controls: some View {
        HStack {
            Button {
                if targetTemperature > config.temperature.minimum {
                    targetDegreesAngle -= temperatureChangeIncrement * config.degreesPerTemperatureUnit
                }
            } label: {
                Text("–")
                    .font(.largeTitle)
            }
            Spacer()
            Button {
                if targetTemperature < config.temperature.maximum {
                    targetDegreesAngle += temperatureChangeIncrement * config.degreesPerTemperatureUnit
                }
            } label: {
                Text("+")
                    .font(.largeTitle)
            }
        }
        .padding(.horizontal, 70)
        .padding(.bottom, 20)
    }
    
    private var targetTemperatureSummary: some View {
        VStack(spacing: 0) {
            Text("TARGET TEMPERATURE")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(TemperatureFormatter.formatted(celcius: targetTemperature))
                .font(.system(size: 48))
                .foregroundColor(.white)
        }
    }
}
