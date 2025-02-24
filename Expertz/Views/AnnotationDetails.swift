//
//  AnnotationDetails.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
// 
//  - Nested View Component for Homepage View
//  - Pulling parameters from Homepage to store for further nested view pages
//  - View used to distinguish and toggle between Client and Expert Map Bubbles
//

import SwiftUI

import SwiftUI

struct AnnotationDetail: View {
    @Binding var selectedAnnotation: MapBubble?
    @Binding var navigateToChatroom: Bool
    @Binding var outerChatId: String
    @Binding var outerRecipientName: String

    var body: some View {
        if let annotation = selectedAnnotation {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.001))
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedAnnotation = nil
                    }
                    .zIndex(0)
                if annotation.type == "Expert" {
                    ExpertAnnotation(annotation: annotation, selectedAnnotation: $selectedAnnotation, navigateToChatroom: $navigateToChatroom, outerChatId: $outerChatId, outerRecipientName: $outerRecipientName)
                        .zIndex(1)
                } else if annotation.type == "Client" {
                    ClientAnnotation(annotation: annotation, selectedAnnotation: $selectedAnnotation, navigateToChatroom: $navigateToChatroom, outerChatId: $outerChatId, outerRecipientName: $outerRecipientName)
                        .zIndex(1)
                }
            }
        }
    }
}
