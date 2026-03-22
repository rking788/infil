//
//  ContentView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var showingPlanRunSheet = false
    @State private var navigationPath = NavigationPath()
    
    // Sample friend plans - TODO: Replace with actual data from backend
    @State private var friendPlans: [FriendRunPlan] = [
        FriendRunPlan(
            username: "Dadcore",
            map: "Perimeter",
            shell: "Vandal",
            date: Date().addingTimeInterval(3600),
            resources: ["Scrap Metal", "Energy Cells", "Titanium Alloy", "Power Core", "Medical Supplies", "Weapon Parts"]
        ),
        FriendRunPlan(
            username: "NateB",
            map: "Dire Marsh",
            shell: "Recon",
            date: Date().addingTimeInterval(7200),
            resources: ["Advanced Circuits", "Fusion Cell", "Alien Artifact"]
        )
    ]
    
    // Accepted/planned runs - TODO: Persist with SwiftData
    @State private var plannedRuns: [PlannedRun] = [
        PlannedRun(
            map: "Outpost",
            date: Date().addingTimeInterval(14400),
            teamComposition: ["Triage", "Vandal", "Recon"],
            resources: ["Power Core", "Medical Supplies"],
            contracts: ["Successful Extraction"]
        )
    ]
    
    private var hasFriendPlans: Bool {
        !friendPlans.isEmpty
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                if hasFriendPlans {
                    RunPlanCardStackView(friendPlans: $friendPlans) { acceptedPlan in
                        handleAcceptedPlan(acceptedPlan)
                    }
                } else {
                    // Empty state
                    emptyStateView
                }
            }
            .marathonBackground()
            .navigationTitle("Infil")
            .marathonNavigationBar()
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .plannedRuns:
                    PlannedRunsView(plannedRuns: $plannedRuns)
                case .profile:
                    ProfileView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigationPath.append(NavigationDestination.plannedRuns)
                    }) {
                        Label("Planned Runs", systemImage: "list.bullet")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigationPath.append(NavigationDestination.profile)
                    }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingPlanRunSheet) {
                CreateRunPlanView()
            }
        }
    }
    
    private func handleAcceptedPlan(_ friendPlan: FriendRunPlan) {
        // Convert FriendRunPlan to PlannedRun
        let plannedRun = PlannedRun(
            map: friendPlan.map,
            date: friendPlan.date,
            teamComposition: [friendPlan.shell], // Start with just the friend's shell
            resources: friendPlan.resources,
            contracts: [] // Friend plans don't have contracts initially
        )
        
        // Add to planned runs
        withAnimation {
            plannedRuns.append(plannedRun)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 12) {
                Image(systemName: "figure.run")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
                
                Text("No Planned Runs")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Plan a run or check back later for invites from friends")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.bottom, 32)
            
            // Main action buttons
            VStack(spacing: 16) {
                Button(action: {
                    showingPlanRunSheet = true
                }) {
                    Text("Plan Run")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    navigationPath.append(NavigationDestination.plannedRuns)
                }) {
                    Text("View Planned Runs")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

// MARK: - Navigation Destinations

enum NavigationDestination: Hashable {
    case plannedRuns
    case profile
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
