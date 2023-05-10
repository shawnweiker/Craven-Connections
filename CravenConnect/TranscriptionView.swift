//
//  TranscriptionView.swift
//  Craven Connections
//
//  Created by Craven on 5/4/23.
//

import SwiftUI
import Firebase

struct TranscriptionView: View {
    @ObservedObject var viewModel: TranscriptionViewModel
    @ObservedObject var invertedViewModel: TranscriptionViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Header
                HStack {
                    Text("Order Summary")
                        .font(.title)
                        .foregroundColor(Color.brandPrimary)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: {
                        // Open the profile screen
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.brandPrimary)
                    }

                    Button(action: {
                        // Open the settings screen
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.brandPrimary)
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 2)

                // Order summary
                ScrollView {
                    VStack {
                        // Design items for order summary
                    }
                }

                // Audio capture and transcription views
                HStack {
                    VStack {
                        // Customer interactions
                        buttonSection(for: viewModel) {
                            viewModel.startRecording()
                        }
                        // Other design items
                    }
                    .frame(width: geometry.size.width / 2)

                    VStack {
                        // Cashier interactions
                        buttonSection(for: invertedViewModel) {
                            invertedViewModel.startRecording()
                        }
                        // Other design items
                    }
                    .frame(width: geometry.size.width / 2)
                }
                .frame(height: geometry.size.height * 0.5)

                // Footer
                HStack {
                    Text("© 2023 Crave IT Arts LLC")
                        .font(.footnote)

                    Spacer()
                }
                .padding()
                .background(Color.brandPrimary)
                .foregroundColor(.white)
            }
        }
    }

    private func buttonSection(for viewModel: TranscriptionViewModel, recordingAction: @escaping () -> Void) -> some View {
        VStack(spacing: 20) {
            if viewModel.recordingState == .notStarted {
                Button(action: {
                    recordingAction()
                }) {
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.brandPrimary)
                }
            } else if viewModel.recordingState == .recording {
                Button(action: {
                    viewModel.stopRecording()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.brandPrimary)
                }
            } else if viewModel.recordingState == .finished {
                Button(action: {
                    // Implement functionality for when recording is finished
                    // For example, you could display a message to the user indicating that the transcription is being processed
                    print("Recording finished")
                }) {
                    Text("Processing")
                        .foregroundColor(Color.brandPrimary)
                }
            } else {
                Text("Error")
            }
        }
    }
}
