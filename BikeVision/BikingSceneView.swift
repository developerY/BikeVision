//
//  BikingSceneView.swift
//  BikeVision
//
//  Created by Siamak Ashrafi on 2/25/25.
//
import SwiftUI
import RealityKit
import RealityKitContent

struct BikingSceneView: View {
    var body: some View {
        RealityView { content in
            do {
                // Load a 3D model (e.g., "bike.usdz") for your scene.
                let bikeEntity = try await ModelEntity.load(named: "bike")

                // Create an anchor and add the bike to it.
                let anchor = AnchorEntity(world: .zero)
                anchor.addChild(bikeEntity)

                // Add the anchor to RealityView content.
                content.add(anchor)

                // Load an HDR environment resource from the bundle.
                // Replace "Skybox" with the actual name of your HDR/EXR file, e.g., "Outdoor.hdr".
                if let environment = try? await EnvironmentResource.load(named: "Skybox",
                                                                         in: realityKitContentBundle) {
                    //content.lighting.environment = environment
                }
            } catch {
                print("Error loading 3D scene: \(error)")
            }
        }
    }
}

// MARK: - Preview

#Preview(immersionStyle: .full) {
    BikingSceneView()
}

