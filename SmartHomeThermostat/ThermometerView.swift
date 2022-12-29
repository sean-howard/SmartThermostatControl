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
    
    private let ringSize: CGFloat = 220
    private let outerDialSize: CGFloat = 200
    
    private let temperatureChangeIncrement: CGFloat = 0.5
    
    @State private var currentTemperature: CGFloat = 0
    @State private var degrees: CGFloat = 36
    @State private var showStatus = false
    
    @State private var x: CGFloat = 0
    @State private var y: CGFloat = 0
    @State private var angle: CGFloat = 0
    
    var targetTemperature: CGFloat {
        let denominator: CGFloat = 1 / temperatureChangeIncrement
        let result: CGFloat = min(max(degrees / 360 * config.markersOnCircumference, config.temperature.minimum), config.temperature.maximum)
        let rounded = round(denominator * result) / denominator
        return rounded
    }
    
    var ringValue: CGFloat {
        return currentTemperature / config.markersOnCircumference
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
                ThermometerScaleView(currentDegrees: degrees)
                
                // MARK: Placeholder
                ThermometerPlaceholderView().hidden()
                
                // MARK: Temperature Ring
                Circle()
                    .inset(by: 5)
                    .trim(
                        from: config.minimumFractionalAngle,
                        to: min(ringValue, config.maximumFractionalAngle)
                    )
                    .stroke(
                        LinearGradient([Color("Temperature Ring 1"), Color("Temperature Ring 2")]),
                        style: .init(lineWidth: 10.0, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(90))
                    .animation(.linear(duration: 1), value: ringValue)
                
                ThermometerDialView(degrees: degrees)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                let x = min(max(value.location.x, 0), outerDialSize)
                                let y = min(max(value.location.y, 0), outerDialSize)
                                
                                self.x = x
                                self.y = y
                                
                                let endPoint = CGPoint(x: x, y: y)
                                let centerPoint = CGPoint(x: outerDialSize / 2, y: outerDialSize / 2)
                                
                                let angle = calculateAngle(centerPoint: centerPoint, endPoint: endPoint)
                                
                                if angle < config.minimumAngle || angle > config.maximumAngle { return }
                                self.angle = angle
                                
                                degrees = angle - angle.remainder(dividingBy: config.degreesPerTemperatureUnit)
                            })
                    )
                
                ThermometerSummaryView(
                    status: status,
                    showStatus: showStatus,
                    temperature: currentTemperature
                )
            }
            HStack {
                Button {
                    if targetTemperature > config.temperature.minimum {
                        degrees -= temperatureChangeIncrement * config.degreesPerTemperatureUnit
                    }
                } label: {
                    Text("–")
                        .font(.largeTitle)
                }
                Spacer()
                Button {
                    if targetTemperature < config.temperature.maximum {
                        degrees += temperatureChangeIncrement * config.degreesPerTemperatureUnit
                    }
                } label: {
                    Text("+")
                        .font(.largeTitle)
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            currentTemperature = 22
            degrees = currentTemperature / config.markersOnCircumference * 360
        }
        .onReceive(timer) { _ in
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
        .onDisappear {
            timer.upstream.connect().cancel()
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
