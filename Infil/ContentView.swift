//
//  ContentView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showPlanRunModal = false
    @State private var showPlannedRuns = false
    @State private var showProfile = false
    
    @State private var runPlanCards: [RunPlanCardData] = [
        RunPlanCardData(map: "Perimeter", user: "Dadcore", resources: ["Unstable Biomass", "Altered Wire"], runDate: Date())
    ] // for demo; empty array means no cards
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let topCard = runPlanCards.first {
                    SwipeableRunPlanCard(card: topCard) {
                        // Remove the top card on swipe
                        withAnimation {
                            runPlanCards.removeFirst()
                        }
                    }
                    .frame(minHeight: 380, maxHeight: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 40)
                } else {
                    VStack(spacing: 20) {
                        Button("Plan Run") {
                            showPlanRunModal = true
                        }
                        Button("View Planned Runs") {
                            showPlannedRuns = true
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Infil")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showPlannedRuns = true
                    } label: {
                        Image(systemName: "list.bullet.rectangle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            .navigationDestination(isPresented: $showPlannedRuns) {
                PlannedRunsView()
            }
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showPlanRunModal) {
                PlanRunModalView()
            }
        }
    }
    
    struct RunPlanCardData: Identifiable {
        let id = UUID()
        let map: String
        let user: String
        let resources: [String]
        let runDate: Date
    }
    
    private struct SwipeableRunPlanCard: View {
        let card: RunPlanCardData
        let onRemove: () -> Void
        
        @State private var offset: CGSize = .zero
        @State private var opacity: Double = 1.0
        
        private let swipeThreshold: CGFloat = 150
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 8)
                
                HStack(spacing: 24) {
                    // Placeholder for map image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 140, height: 140)
                        .overlay(
                            Text("Map Image")
                                .font(.headline)
                                .foregroundColor(.gray)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(card.map)
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        Text("User: \(card.user)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Resources: \(card.resources.joined(separator: ", "))")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        Text(card.runDate, style: .date)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(30)
            }
            .offset(offset)
            .opacity(opacity)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        withAnimation(.easeOut(duration: 0.3)) {
                            if abs(gesture.translation.width) > swipeThreshold {
                                // Animate off screen
                                opacity = 0
                                offset.width = gesture.translation.width > 0 ? 1000 : -1000
                                
                                // Call onRemove after animation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    onRemove()
                                    offset = .zero
                                    opacity = 1.0
                                }
                            } else {
                                offset = .zero
                            }
                        }
                    }
            )
        }
    }
    
    private struct PlannedRunsView: View {
        var body: some View {
            NavigationStack {
                List {
                    // Empty list
                }
                .navigationTitle("Planned Runs")
            }
        }
    }
    
    private struct PlanRunModalView: View {
        @Environment(\.dismiss) var dismiss
        
        @State private var username: String = "rking788"
        @State private var selectedMap: String = "Perimeter"
        @State private var runTime: Date = Date()
        @State private var notes: String = ""
        
        private let maps = ["Perimeter", "Outpost", "Dire Marsh", "Cryo"]
        private let resources = ["Unstable Biomass", "Altered Wire", "Unstable Gunmetal", "Unstable Diode"]
        @State private var selectedResources: Set<String> = []
        
        var body: some View {
            NavigationStack {
                Form {
                    Section {
                        TextField("Username", text: $username)
                            .disabled(true)
                        Picker("Map", selection: $selectedMap) {
                            ForEach(maps, id: \.self) { map in
                                Text(map)
                            }
                        }
                        DatePicker("Run Time", selection: $runTime, displayedComponents: [.date, .hourAndMinute])
                        TextField("Notes (optional)", text: $notes)
                    }
                    
                    Section("Resources/Salvage") {
                        ForEach(resources, id: \.self) { resource in
                            Toggle(resource, isOn: Binding(
                                get: { selectedResources.contains(resource) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedResources.insert(resource)
                                    } else {
                                        selectedResources.remove(resource)
                                    }
                                }
                            ))
                        }
                    }
                    
                    Section {
                        Button("Save") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Section {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Plan Run")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private struct ProfileView: View {
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.secondary)
                Text("rking788")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.top, 8)
                Spacer()
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
