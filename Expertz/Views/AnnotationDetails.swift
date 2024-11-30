//
//  AnnotationDetails.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI

import SwiftUI

struct AnnotationDetail: View {
    @Binding var selectedAnnotation: MapBubble?

    var body: some View {
        if let annotation = selectedAnnotation {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedAnnotation = nil
                    }
                    .zIndex(0)
                if annotation.type == "Expert" {
                    ExpertAnnotation(annotation: annotation, selectedAnnotation: $selectedAnnotation)
                        .zIndex(1)
                } else if annotation.type == "Client" {
                    ClientAnnotation(annotation: annotation, selectedAnnotation: $selectedAnnotation)
                        .zIndex(1)
                }
            }
        }
    }
}
