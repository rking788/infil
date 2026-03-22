import Foundation

struct SalvageItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

extension SalvageItem {
    static let all: [SalvageItem] = [
        "Compiler Ganglion", "Alien Alloy", "Biogenic Alloy", "Hazard Capsule", "Synapse Cube",
        "Ballistic Turbine", "Biofilament", "Biolens Seed", "Coherence Drive", "Enzyme Replicator",
        "Liquid Explosive", "Neural Insulation", "Papaver Bloom", "Predictive Framework", "Reflex Coil",
        "Shell ID", "Amygdala Drive", "Anomalous Wire", "Biomata Node", "Biomata Resin",
        "Cetinite Rods", "Dynamic Lens", "Nanozymes", "Neurochem Pack", "Paradox Circuit",
        "Polymer Wire", "Steel Rods", "Sterilized Biostripping", "Tachyon Filament", "Tarax Seed",
        "Thoughtwave Lens", "UESC Obedience Matrix", "Volatile Compounds", "Aluminum Rods", "Basic Xerogel",
        "Carbon Wire", "Deimosite Rods", "Dermachem Pack", "Drone Node", "Drone Resin",
        "Unstable Biomass", "Unstable Diode", "Unstable Gunmetal", "Unstable Lead", "Unstable Gel"
    ].map { SalvageItem(name: $0) }
}
