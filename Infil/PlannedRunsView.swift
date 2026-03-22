//
//  PlannedRunsView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI

struct PlannedRunsView: View {
    @Binding var plannedRuns: [PlannedRun]
    
    var body: some View {
        Group {
            if plannedRuns.isEmpty {
                ContentUnavailableView(
                    "No Planned Runs",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Accept run invitations to see them here")
                )
                .foregroundStyle(Color.marathonTextPrimary)
            } else {
                List {
                    ForEach(plannedRuns) { run in
                        NavigationLink {
                            PlannedRunDetailView(run: run)
                        } label: {
                            PlannedRunRowView(run: run)
                        }
                    }
                    .onDelete(perform: deleteRuns)
                    .listRowBackground(Color.marathonCard)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .marathonBackground()
        .navigationTitle("Planned Runs")
        .navigationBarTitleDisplayMode(.large)
        .marathonNavigationBar()
    }
    
    private func deleteRuns(at offsets: IndexSet) {
        plannedRuns.remove(atOffsets: offsets)
    }
}

struct PlannedRunRowView: View {
    let run: PlannedRun
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Map and Date/Time
            HStack {
                Label(run.map, systemImage: "map.fill")
                    .font(MarathonFontStyle.headline)
                    .foregroundStyle(Color.marathonTextPrimary)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(run.date, style: .date)
                        .font(MarathonFontStyle.caption)
                        .foregroundStyle(Color.marathonTextSecondary)
                    Text(run.date, style: .time)
                        .font(MarathonFontStyle.caption)
                        .foregroundStyle(Color.marathonTextSecondary)
                }
            }
            
            // Team Composition
            HStack(spacing: 4) {
                Text("Team:")
                    .font(MarathonFontStyle.caption)
                    .foregroundStyle(Color.marathonTextSecondary)
                
                ForEach(run.teamComposition, id: \.self) { shell in
                    MarathonShellIcon(shell: shell, size: 20)
                }
                
                Spacer()
                
                // Participant count
                Text("\(run.teamComposition.count) runners")
                    .font(MarathonFontStyle.caption2)
                    .foregroundStyle(Color.marathonTextSecondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func shellIcon(for shell: String) -> String {
        switch shell.lowercased() {
        case "triage": return "cross.case.fill"
        case "vandal": return "flame.fill"
        case "thief": return "hand.raised.slash"
        case "destroyer": return "burst.fill"
        case "assassin": return "scope"
        case "recon": return "eye.fill"
        default: return "eye.fill"
        }
    }
}

// MARK: - Planned Run Detail View

struct PlannedRunDetailView: View {
    let run: PlannedRun
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Map") {
                    Text(run.map)
                        .foregroundStyle(Color.marathonTextPrimary)
                }
                LabeledContent("Date") {
                    Text(run.date, style: .date)
                        .foregroundStyle(Color.marathonTextPrimary)
                }
                LabeledContent("Time") {
                    Text(run.date, style: .time)
                        .foregroundStyle(Color.marathonTextPrimary)
                }
            } header: {
                Text("Run Details")
                    .marathonSectionHeader()
            }
            .listRowBackground(Color.marathonCard)
            
            Section {
                ForEach(run.teamComposition, id: \.self) { shell in
                    HStack(spacing: 12) {
                        MarathonShellIcon(shell: shell, size: 24)
                        Text(shell)
                            .foregroundStyle(Color.marathonTextPrimary)
                    }
                }
            } header: {
                Text("Team Composition")
                    .marathonSectionHeader()
            }
            .listRowBackground(Color.marathonCard)
            
            if !run.resources.isEmpty {
                Section {
                    ForEach(run.resources, id: \.self) { resource in
                        Text(resource)
                            .foregroundStyle(Color.marathonTextPrimary)
                    }
                } header: {
                    Text("Target Resources")
                        .marathonSectionHeader()
                }
                .listRowBackground(Color.marathonCard)
            }
            
            if !run.contracts.isEmpty {
                Section {
                    ForEach(run.contracts, id: \.self) { contract in
                        Text(contract)
                            .foregroundStyle(Color.marathonTextPrimary)
                    }
                } header: {
                    Text("Contracts")
                        .marathonSectionHeader()
                }
                .listRowBackground(Color.marathonCard)
            }
        }
        .scrollContentBackground(.hidden)
        .marathonBackground()
        .navigationTitle("Run Details")
        .navigationBarTitleDisplayMode(.inline)
        .marathonNavigationBar()
    }
    
    private func shellIcon(for shell: String) -> String {
        switch shell.lowercased() {
        case "triage": return "cross.case.fill"
        case "vandal": return "flame.fill"
        case "thief": return "hand.raised.slash"
        case "destroyer": return "burst.fill"
        case "assassin": return "scope"
        case "recon": return "eye.fill"
        default: return "eye.fill"
        }
    }
}

// MARK: - Supporting Types

struct PlannedRun: Identifiable, Equatable {
    let id = UUID()
    let map: String
    let date: Date
    let teamComposition: [String] // Array of shell names
    let resources: [String]
    let contracts: [String]
    
    static func == (lhs: PlannedRun, rhs: PlannedRun) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview("With Runs") {
    NavigationStack {
        PlannedRunsView(plannedRuns: .constant([
            PlannedRun(
                map: "Perimeter",
                date: Date().addingTimeInterval(3600),
                teamComposition: ["Vandal", "Recon", "Triage"],
                resources: ["Ceramic Plates", "Mk1 Optics", "Power Cell"],
                contracts: ["Successful Extraction"]
            ),
            PlannedRun(
                map: "Dire Marsh",
                date: Date().addingTimeInterval(7200),
                teamComposition: ["Assassin", "Thief"],
                resources: ["Alien Tech Fragment", "Fusion Core"],
                contracts: ["Salvage Collection", "Reconnaissance"]
            ),
            PlannedRun(
                map: "Cryo",
                date: Date().addingTimeInterval(10800),
                teamComposition: ["Destroyer", "Vandal", "Triage", "Recon"],
                resources: ["Mk2 CPU"],
                contracts: []
            )
        ]))
    }
}

#Preview("Empty State") {
    NavigationStack {
        PlannedRunsView(plannedRuns: .constant([]))
    }
}
