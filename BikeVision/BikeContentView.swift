//
//  BikeContentView.swift
//  BikeVision
//
//  Created by Siamak Ashrafi on 2/23/25.
//
import SwiftUI

struct BikeContentView: View {
    var body: some View {
        ZStack {
            // In a more complex app, you might use a live camera feed or 3D scene here.
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Overlaying bike ride metrics
            VStack(spacing: 20) {
                Text("Cycling Companion")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 40) {
                    // Speed metric
                    VStack {
                        Text("Speed")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("12 mph")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                    
                    // Distance metric
                    VStack {
                        Text("Distance")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("3.4 mi")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
            .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    BikeContentView()
        .environment(AppModel())
}

