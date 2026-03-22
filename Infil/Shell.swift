import Foundation

enum Shell: String, CaseIterable, Identifiable {
    case thief = "Thief"
    case vandal = "Vandal"
    case triage = "Triage"
    case assassin = "Assassin"
    case breacher = "Breacher"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .thief: return "figure.walk.motion"
        case .vandal: return "hammer.fill"
        case .triage: return "cross.case.fill"
        case .assassin: return "scope"
        case .breacher: return "shield.fill"
        }
    }
}
