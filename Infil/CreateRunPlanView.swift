//
//  CreateRunPlanView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI

struct CreateRunPlanView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Form fields
    @State private var selectedMap: MarathonMap?
    @State private var selectedShell: Shell = .triage
    @State private var selectedDate = Date()
    @State private var selectedResources: Set<SalvageResource> = []
    @State private var selectedContracts: Set<Contract> = []
    @State private var expandedContracts: Set<Contract> = []
    
    var body: some View {
        NavigationStack {
            Form {
                // Map Selection
                Section {
                    Picker("Map", selection: $selectedMap) {
                        Text("Select a map").tag(nil as MarathonMap?)
                        ForEach(MarathonMap.allCases) { map in
                            Text(map.rawValue).tag(map as MarathonMap?)
                        }
                    }
                    .foregroundStyle(Color.marathonTextPrimary)
                    
                    if let selectedMap = selectedMap {
                        // Map preview image placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.marathonSurface)
                                .frame(height: 200)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color.marathonPrimary)
                                Text(selectedMap.rawValue)
                                    .font(MarathonFontStyle.headline)
                                    .foregroundStyle(Color.marathonTextPrimary)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal)
                    }
                } header: {
                    Text("Location")
                        .marathonSectionHeader()
                }
                .listRowBackground(Color.marathonCard)
                
                // Shell Selection
                Section {
                    Picker("Your Shell", selection: $selectedShell) {
                        ForEach(Shell.allCases) { shell in
                            Label(shell.rawValue, systemImage: shell.icon)
                                .tag(shell)
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundStyle(Color.marathonTextPrimary)
                } header: {
                    Text("Shell")
                        .marathonSectionHeader()
                } footer: {
                    Text("Select the character type you'll be using for this run")
                        .foregroundStyle(Color.marathonTextSecondary)
                }
                .listRowBackground(Color.marathonCard)
                
                // Date and Time
                Section {
                    DatePicker("Scheduled Time", selection: $selectedDate, in: Date()...)
                        .datePickerStyle(.compact)
                        .foregroundStyle(Color.marathonTextPrimary)
                } header: {
                    Text("Schedule")
                        .marathonSectionHeader()
                }
                .listRowBackground(Color.marathonCard)
                
                // Resources/Salvage Selection
                Section {
                    NavigationLink {
                        ResourceSelectionView(selectedResources: $selectedResources)
                    } label: {
                        HStack {
                            Text("Resources")
                                .foregroundStyle(Color.marathonTextPrimary)
                            Spacer()
                            if selectedResources.isEmpty {
                                Text("None")
                                    .foregroundStyle(Color.marathonTextSecondary)
                            } else {
                                Text("\(selectedResources.count) selected")
                                    .foregroundStyle(Color.marathonTextSecondary)
                            }
                        }
                    }
                    
                    if !selectedResources.isEmpty {
                        ForEach(Array(selectedResources).sorted(by: { $0.name < $1.name }), id: \.self) { resource in
                            HStack {
                                Label {
                                    Text(resource.name)
                                        .foregroundStyle(Color.marathonTextPrimary)
                                } icon: {
                                    Circle()
                                        .fill(resource.rarity.color)
                                        .frame(width: 8, height: 8)
                                }
                                Spacer()
                                Text(resource.rarity.rawValue)
                                    .font(MarathonFontStyle.caption)
                                    .foregroundStyle(Color.marathonTextSecondary)
                            }
                        }
                    }
                } header: {
                    Text("Salvage & Resources")
                        .marathonSectionHeader()
                } footer: {
                    Text("Select the resources you're seeking during this run")
                        .foregroundStyle(Color.marathonTextSecondary)
                }
                .listRowBackground(Color.marathonCard)
                
                // Contracts Selection
                Section {
                    ForEach(Contract.allCases) { contract in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Button(action: {
                                    if selectedContracts.contains(contract) {
                                        selectedContracts.remove(contract)
                                        expandedContracts.remove(contract)
                                    } else {
                                        selectedContracts.insert(contract)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: selectedContracts.contains(contract) ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(selectedContracts.contains(contract) ? Color.marathonPrimary : Color.marathonTextSecondary)
                                        
                                        Text(contract.rawValue)
                                            .foregroundStyle(Color.marathonTextPrimary)
                                        
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if selectedContracts.contains(contract) {
                                    Button(action: {
                                        if expandedContracts.contains(contract) {
                                            expandedContracts.remove(contract)
                                        } else {
                                            expandedContracts.insert(contract)
                                        }
                                    }) {
                                        Image(systemName: expandedContracts.contains(contract) ? "chevron.up" : "chevron.down")
                                            .font(MarathonFontStyle.caption)
                                            .foregroundStyle(Color.marathonTextSecondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            if selectedContracts.contains(contract) && expandedContracts.contains(contract) {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(contract.requirements, id: \.self) { requirement in
                                        HStack(alignment: .top, spacing: 8) {
                                            Image(systemName: "circle.fill")
                                                .font(.system(size: 4))
                                                .foregroundStyle(Color.marathonTextSecondary)
                                                .padding(.top, 6)
                                            Text(requirement)
                                                .font(MarathonFontStyle.caption)
                                                .foregroundStyle(Color.marathonTextSecondary)
                                        }
                                    }
                                }
                                .padding(.leading, 28)
                                .padding(.top, 4)
                            }
                        }
                    }
                } header: {
                    Text("Contracts")
                        .marathonSectionHeader()
                } footer: {
                    Text("Select contracts you're planning to complete during this run")
                        .foregroundStyle(Color.marathonTextSecondary)
                }
                .listRowBackground(Color.marathonCard)
            }
            .scrollContentBackground(.hidden)
            .marathonBackground()
            .navigationTitle("Plan Run")
            .navigationBarTitleDisplayMode(.inline)
            .marathonNavigationBar()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.marathonTextSecondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRunPlan()
                    }
                    .disabled(selectedMap == nil)
                    .foregroundStyle(selectedMap == nil ? Color.marathonTextTertiary : Color.marathonPrimary)
                }
            }
        }
    }
    
    private func saveRunPlan() {
        // TODO: Implement saving run plan to SwiftData and backend
        print("Saving run plan...")
        print("Map: \(selectedMap?.rawValue ?? "None")")
        print("Shell: \(selectedShell.rawValue)")
        print("Date: \(selectedDate)")
        print("Resources: \(selectedResources.count)")
        print("Contracts: \(selectedContracts.count)")
        
        dismiss()
    }
}

// MARK: - Supporting Types

enum MarathonMap: String, CaseIterable, Identifiable {
    case perimeter = "Perimeter"
    case outpost = "Outpost"
    case cryo = "Cryo"
    case direMarsh = "Dire Marsh"
    
    var id: String { rawValue }
}

enum Shell: String, CaseIterable, Identifiable {
    case triage = "Triage"
    case vandal = "Vandal"
    case thief = "Thief"
    case destroyer = "Destroyer"
    case assassin = "Assassin"
    case recon = "Recon"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .triage: return "cross.case.fill"
        case .vandal: return "flame.fill"
        case .thief: return "hand.raised.slash"
        case .destroyer: return "burst.fill"
        case .assassin: return "scope"
        case .recon: return "eye.fill"
        }
    }
}

enum SalvageRarity: String {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: Color {
        switch self {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}

struct SalvageResource: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let rarity: SalvageRarity
    let category: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: SalvageResource, rhs: SalvageResource) -> Bool {
        lhs.name == rhs.name
    }
}

enum Contract: String, CaseIterable, Identifiable {
    case extraction = "Successful Extraction"
    case elimination = "Runner Elimination"
    case salvageCollection = "Salvage Collection"
    case territorialControl = "Territorial Control"
    case reconnaissance = "Reconnaissance"
    
    var id: String { rawValue }
    
    var requirements: [String] {
        switch self {
        case .extraction:
            return [
                "Extract with at least 3 high-value items",
                "No team members left behind",
                "Complete within 45 minutes"
            ]
        case .elimination:
            return [
                "Eliminate 5+ enemy runners",
                "Collect dogtags from eliminated runners",
                "Survive to extraction"
            ]
        case .salvageCollection:
            return [
                "Collect 10+ rare salvage items",
                "Identify all salvage types in target area",
                "Extract successfully with collection"
            ]
        case .territorialControl:
            return [
                "Control 3 key locations for 5 minutes each",
                "Defend against counter-attacks",
                "Mark controlled areas on map"
            ]
        case .reconnaissance:
            return [
                "Scout 5+ marked locations",
                "Document enemy positions",
                "Return intel to extraction point"
            ]
        }
    }
}

// MARK: - Resource Selection View

struct ResourceSelectionView: View {
    @Binding var selectedResources: Set<SalvageResource>
    @Environment(\.dismiss) private var dismiss
    
    // Salvage resources based on https://tauceti.gg/db/salvage
    private let salvageResources: [SalvageResource] = [
        // Common
        SalvageResource(name: "Ceramic Plates", rarity: .common, category: "Armor"),
        SalvageResource(name: "Copper Wire", rarity: .common, category: "Electronics"),
        SalvageResource(name: "Scrap Metal", rarity: .common, category: "Materials"),
        SalvageResource(name: "Plastic Fragments", rarity: .common, category: "Materials"),
        SalvageResource(name: "Broken Optics", rarity: .common, category: "Optics"),
        
        // Uncommon
        SalvageResource(name: "Mk1 Optics", rarity: .uncommon, category: "Optics"),
        SalvageResource(name: "Heat Sink", rarity: .uncommon, category: "Cooling"),
        SalvageResource(name: "Weapon Parts", rarity: .uncommon, category: "Weapons"),
        SalvageResource(name: "Salvaged Armor", rarity: .uncommon, category: "Armor"),
        SalvageResource(name: "Power Cell", rarity: .uncommon, category: "Power"),
        SalvageResource(name: "Med Kit", rarity: .uncommon, category: "Medical"),
        SalvageResource(name: "Aluminum Alloy", rarity: .uncommon, category: "Materials"),
        
        // Rare
        SalvageResource(name: "Mk2 CPU", rarity: .rare, category: "Electronics"),
        SalvageResource(name: "Mk2 Optics", rarity: .rare, category: "Optics"),
        SalvageResource(name: "Titanium Plating", rarity: .rare, category: "Armor"),
        SalvageResource(name: "Rare Ore", rarity: .rare, category: "Materials"),
        SalvageResource(name: "Advanced Heat Sink", rarity: .rare, category: "Cooling"),
        SalvageResource(name: "High-Cap Battery", rarity: .rare, category: "Power"),
        SalvageResource(name: "Combat Stim", rarity: .rare, category: "Medical"),
        
        // Epic
        SalvageResource(name: "Mk3 CPU", rarity: .epic, category: "Electronics"),
        SalvageResource(name: "Mk3 Optics", rarity: .epic, category: "Optics"),
        SalvageResource(name: "Composite Armor", rarity: .epic, category: "Armor"),
        SalvageResource(name: "Exotic Alloy", rarity: .epic, category: "Materials"),
        SalvageResource(name: "Fusion Core", rarity: .epic, category: "Power"),
        SalvageResource(name: "Advanced Weapon System", rarity: .epic, category: "Weapons"),
        
        // Legendary
        SalvageResource(name: "Alien Tech Fragment", rarity: .legendary, category: "Artifacts"),
        SalvageResource(name: "Experimental CPU", rarity: .legendary, category: "Electronics"),
        SalvageResource(name: "Prototype Weapon", rarity: .legendary, category: "Weapons"),
        SalvageResource(name: "Quantum Battery", rarity: .legendary, category: "Power"),
    ]
    
    private var groupedResources: [SalvageRarity: [SalvageResource]] {
        Dictionary(grouping: salvageResources, by: { $0.rarity })
    }
    
    var body: some View {
        List {
            ForEach([SalvageRarity.legendary, .epic, .rare, .uncommon, .common], id: \.self) { rarity in
                if let resources = groupedResources[rarity] {
                    Section {
                        ForEach(resources) { resource in
                            Button(action: {
                                if selectedResources.contains(resource) {
                                    selectedResources.remove(resource)
                                } else {
                                    selectedResources.insert(resource)
                                }
                            }) {
                                HStack {
                                    Circle()
                                        .fill(rarity.color)
                                        .frame(width: 12, height: 12)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(resource.name)
                                            .foregroundStyle(Color.marathonTextPrimary)
                                        Text(resource.category)
                                            .font(MarathonFontStyle.caption)
                                            .foregroundStyle(Color.marathonTextSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedResources.contains(resource) {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color.marathonPrimary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .listRowBackground(Color.marathonCard)
                    } header: {
                        Text(rarity.rawValue)
                            .marathonSectionHeader()
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .marathonBackground()
        .navigationTitle("Select Resources")
        .navigationBarTitleDisplayMode(.inline)
        .marathonNavigationBar()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
                .foregroundStyle(Color.marathonPrimary)
            }
        }
    }
}

#Preview {
    CreateRunPlanView()
}

#Preview("Resource Selection") {
    NavigationStack {
        ResourceSelectionView(selectedResources: .constant([]))
    }
}
