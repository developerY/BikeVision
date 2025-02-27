//
//  ForestContentView.swift
//  BikeVision
//
//  Created by Siamak Ashrafi on 2/26/25.
//


import SwiftUI
import RealityKit
import RealityKitContent  // contains 3D assets like the forest scene

struct ForestContentView: View {
    @State private var sphereEntity: ModelEntity? = nil  // reference to sphere for interactions

    var body: some View {
        RealityView { content in
            // 1. Create an anchor for the whole scene
            let sceneAnchor = AnchorEntity(world: .zero)
            
            // 2. Load the digital forest environment (from assets) and add to anchor
            if let forestScene = try? await Entity(named: "ForestScene", in: realityKitContentBundle) {
                sceneAnchor.addChild(forestScene)
            }
            
            // 3. Create a translucent panel (semi-transparent plane)
            let panelMesh = MeshResource.generatePlane(width: 1.0, height: 0.6)
            let panelMaterial = SimpleMaterial(color: .white.withAlphaComponent(0.5), roughness: 0.2, isMetallic: false)
            let panelEntity = ModelEntity(mesh: panelMesh, materials: [panelMaterial])
            panelEntity.position = SIMD3<Float>(0, 1.0, -2.0)   // 1m high, 2m in front of user
            sceneAnchor.addChild(panelEntity)
            
            // 4. Create the interactive crystalline sphere
            let sphereMesh = MeshResource.generateSphere(radius: 0.2)
            var sphereMaterial = SimpleMaterial()
            sphereMaterial.color = .init(tint: .cyan.withAlphaComponent(0.6), texture: nil)
            sphereMaterial.metallic = 1.0
            sphereMaterial.roughness = 0.1
            let sphere = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
            sphere.position = SIMD3<Float>(0, 1.2, -1.5)       // float at eye-level, closer to user
            sphere.generateCollisionShapes(recursive: true)   // enable collisions for input
            sphere.components.set(InputTargetComponent(allowedInputTypes: .all))  // make tappable
            sceneAnchor.addChild(sphere)
            self.sphereEntity = sphere  // keep reference for gesture handling
            
            // 5. Add lighting to the scene (e.g. a directional light as "sunlight")
            let sunLight = DirectionalLight()
            //sunLight.intensity = 100000
            sunLight.light.color = .white
            sunLight.orientation = simd_quatf(angle: -.pi/4, axis: SIMD3<Float>(1, 0, 0))  // tilt 45° downward
            sceneAnchor.addChild(sunLight)
            // Optionally add image-based ambient light from a forest environment map
            if let forestLight = try? await EnvironmentResource(named: "ForestEnv") {
                sceneAnchor.components.set(
                    ImageBasedLightComponent(source: .single(forestLight), intensityExponent: 1.0)
                )
                sceneAnchor.components.set(
                    ImageBasedLightReceiverComponent(imageBasedLight: sceneAnchor)
                )
            }
            
            // 6. Add the anchor with all content to the RealityView
            content.add(sceneAnchor)
        }
        /* 7. Attach gesture recognizer for tapping the sphere
        .gesture(
            TapGesture()
                .targetedToAnyEntity()   // detect taps on any 3D entity in this view
                .onEnded { tap in
                    if let tappedEntity = tap.entity, tappedEntity == sphereEntity {
                        // Change the sphere's color when it's tapped
                        if var material = sphereEntity?.model?.materials.first as? SimpleMaterial {
                            material.color = .init(tint: .purple, texture: nil)
                            sphereEntity?.model?.materials = [material]
                        }
                    }
                }
        )*/
    }
}

struct ForestContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForestContentView()
            .previewInterfaceOrientation(.landscapeLeft) // Adjust orientation as needed
    }
}

