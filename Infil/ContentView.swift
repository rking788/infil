//
//  ContentView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingPlanRunModal = false
    @State private var runPlans: [RunPlan] = RunPlan.allMocks

    var body: some View {
        NavigationStack {
            ZStack {
                if runPlans.isEmpty {
                    emptyStateView
                } else {
                    cardStackView
                }
            }
            .navigationTitle("Infil")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: Text("Planned Runs View")) {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .imageScale(.large)
                            .accessibilityLabel("View Planned Runs List")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Text("Profile View")) {
                        Image(systemName: "person.crop.circle.fill")
                            .imageScale(.large)
                            .accessibilityLabel("View Profile")
                    }
                }
            }
            .sheet(isPresented: $showingPlanRunModal) {
                Text("Create a Run Plan View")
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Button(action: {
                showingPlanRunModal = true
            }) {
                Text("Plan Run")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.marathonYellow)
            .foregroundColor(.black)

            NavigationLink(destination: Text("Planned Runs View")) {
                Text("View Planned Runs")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            Spacer()
        }
        .padding(.horizontal, 24)
    }

    private var cardStackView: some View {
        VStack {
            ZStack {
                let displayPlans = Array(runPlans.prefix(3))
                
                ForEach(Array(displayPlans.enumerated().reversed()), id: \.element.id) { index, plan in
                    RunPlanCardView(plan: plan) { outcome in
                        withAnimation {
                            runPlans.removeAll { $0.id == plan.id }
                        }
                    }
                    .offset(y: CGFloat(index) * 12)
                    .scaleEffect(1.0 - CGFloat(index) * 0.03)
                    .zIndex(Double(displayPlans.count - index))
                }
            }
            .padding()
            .padding(.bottom, 20)

            HStack(spacing: 30) {
                Button(action: {
                    showingPlanRunModal = true
                }) {
                    Label("Plan Run", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Button(action: {
                    // Refresh or add back for testing
                    withAnimation {
                        runPlans = RunPlan.allMocks
                    }
                }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.borderless)
            }
            .padding(.bottom)
        }
    }
}

extension Color {
    static let marathonYellow = Color(red: 0.95, green: 0.98, blue: 0.1) // Bright neon yellow
}

#Preview {
    ContentView()
}
