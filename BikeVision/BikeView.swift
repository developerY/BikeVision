//
//  BikeView.swift
//  BikeVision
//
//  Created by Siamak Ashrafi on 2/23/25.
//
import SwiftUI
import Combine

// A simple mock BLE manager to simulate connected state for previews.
class MockBLEManager: BLEManager {
    
    override init() {
            super.init()
            // Provide mock data for previews
            self.isConnected = true
            self.bikeName = "Simulated Bike"
            self.sensorData = "0x1a2b3c"
        }
    
    
    
}

struct BikeView: View {
    // For real usage, you'd use BLEManager(), but for testing, we can inject a mock.
    @StateObject var bleManager: BLEManager
    
    var body: some View {
        VStack(spacing: 20) {
            if bleManager.isConnected {
                Text("Connected to: \(bleManager.bikeName)")
                    .font(.headline)
                    .padding()
                Text("Sensor Data:")
                    .font(.subheadline)
                Text(bleManager.sensorData)
                    .font(.body)
                    .padding()
            } else {
                Text("Scanning for bike...")
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear {
            // In a real app, BLE scanning would start in BLEManager's init.
        }
        .padding()
    }
}

// MARK: - Previews

// A wrapper view to inject a mock BLE manager into BikeView for preview purposes.
struct BikeView_PreviewWrapper: View {
    @StateObject var mockManager = MockBLEManager() as BLEManager
    
    var body: some View {
        BikeView(bleManager: mockManager)
    }
}

struct BikeView_Previews: PreviewProvider {
    static var previews: some View {
        BikeView_PreviewWrapper()
    }
}


