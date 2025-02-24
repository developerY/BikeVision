//
//  BikeView.swift
//  BikeVision
//
//  Created by Siamak Ashrafi on 2/23/25.
//
import SwiftUI

struct BikeView: View {
    @StateObject var bleManager = BLEManager()

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
            // BLE scanning starts in BLEManager's init. You can add additional logic here if needed.
        }
        .padding()
    }
}

struct BikeView_Previews: PreviewProvider {
    static var previews: some View {
        BikeView()
    }
}

