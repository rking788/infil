import Foundation

struct RunPlan: Identifiable {
    let id = UUID()
    let mapName: String
    let creatorName: String
    let plannedAt: Date
    let resources: [String]
    let contracts: [String]
}

extension RunPlan {
    static let mockPerimeter = RunPlan(
        mapName: "Perimeter",
        creatorName: "rking788",
        plannedAt: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 30, hour: 21)) ?? Date(),
        resources: [],
        contracts: []
    )
    
    static let mockIsolation = RunPlan(
        mapName: "Isolation",
        creatorName: "ghost_runner",
        plannedAt: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 31, hour: 18)) ?? Date(),
        resources: ["Silicon", "Battery"],
        contracts: ["Data Retrieval"]
    )
    
    static let mockCatacombs = RunPlan(
        mapName: "Catacombs",
        creatorName: "bungie_fan",
        plannedAt: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1, hour: 20)) ?? Date(),
        resources: ["Rare Metal"],
        contracts: []
    )
    
    static let allMocks = [mockCatacombs, mockIsolation, mockPerimeter]
}
