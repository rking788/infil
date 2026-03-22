//
//  RunPlanCardStackView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI

struct RunPlanCardStackView: View {
    @Binding var friendPlans: [FriendRunPlan]
    var onAccept: (FriendRunPlan) -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            if friendPlans.isEmpty {
                // This will trigger the parent to show empty state
                Color.clear
            } else {
                ForEach(Array(friendPlans.enumerated().reversed()), id: \.element.id) { index, plan in
                    if index >= currentIndex {
                        RunPlanCardView(plan: plan)
                            .zIndex(Double(friendPlans.count - index))
                            .offset(
                                x: index == currentIndex ? dragOffset.width : 0,
                                y: index == currentIndex ? dragOffset.height : 0
                            )
                            .rotationEffect(.degrees(index == currentIndex ? Double(dragOffset.width / 20) : 0))
                            .scaleEffect(index == currentIndex ? 1.0 : 0.95)
                            .opacity(index == currentIndex ? 1.0 : 0.8)
                            .gesture(
                                index == currentIndex ? DragGesture()
                                    .onChanged { gesture in
                                        dragOffset = gesture.translation
                                    }
                                    .onEnded { gesture in
                                        handleSwipeEnd(translation: gesture.translation, plan: plan)
                                    } : nil
                            )
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
                    }
                }
            }
        }
    }
    
    private func handleSwipeEnd(translation: CGSize, plan: FriendRunPlan) {
        let swipeThreshold: CGFloat = 100
        
        if abs(translation.width) > swipeThreshold {
            // Determine if swiped right (accept) or left (decline)
            let isAccepted = translation.width > 0
            
            // Swiped left or right
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                dragOffset = CGSize(
                    width: translation.width > 0 ? 500 : -500,
                    height: translation.height
                )
            }
            
            // Move to next card after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // If accepted, notify parent
                if isAccepted {
                    onAccept(plan)
                }
                
                currentIndex += 1
                dragOffset = .zero
                
                // Remove the card from the stack
                if currentIndex <= friendPlans.count {
                    friendPlans.removeFirst()
                    currentIndex = 0
                }
            }
        } else {
            // Return to center
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                dragOffset = .zero
            }
        }
    }
}

struct RunPlanCardView: View {
    let plan: FriendRunPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with username
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.marathonPrimary)
                
                Text(plan.username)
                    .font(MarathonFontStyle.headline)
                    .foregroundStyle(Color.marathonTextPrimary)
                
                Spacer()
                
                Text(plan.date, style: .date)
                    .font(MarathonFontStyle.caption)
                    .foregroundStyle(Color.marathonTextSecondary)
            }
            
            Divider()
                .background(Color.marathonBorder)
            
            // Map info
            VStack(alignment: .leading, spacing: 8) {
                Label(plan.map, systemImage: "map.fill")
                    .font(MarathonFontStyle.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.marathonTextPrimary)
                
                Text(plan.date, style: .time)
                    .font(MarathonFontStyle.subheadline)
                    .foregroundStyle(Color.marathonTextSecondary)
            }
            
            // Shell selection
            HStack {
                Text("Shell:")
                    .foregroundStyle(Color.marathonTextSecondary)
                
                MarathonShellIcon(shell: plan.shell, size: 20)
                
                Text(plan.shell)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.marathonTextPrimary)
                
                Spacer()
            }
            .font(MarathonFontStyle.subheadline)
            
            if !plan.resources.isEmpty {
                Divider()
                    .background(Color.marathonBorder)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Seeking Resources")
                        .marathonSectionHeader()
                    
                    FlowLayout(spacing: 8) {
                        ForEach(plan.resources.prefix(5), id: \.self) { resource in
                            MarathonResourceTag(resource, color: Color.marathonPrimary)
                        }
                        
                        if plan.resources.count > 5 {
                            Text("+\(plan.resources.count - 5)")
                                .font(MarathonFontStyle.caption)
                                .foregroundStyle(Color.marathonTextSecondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Swipe instructions
            HStack {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.marathonDanger)
                Spacer()
                Text("Swipe to respond")
                    .font(MarathonFontStyle.caption)
                    .foregroundStyle(Color.marathonTextSecondary)
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.marathonSuccess)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .marathonCard(glowColor: Color.marathonPrimary)
        .padding(.horizontal, 32)
        .padding(.vertical, 60)
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

struct FriendRunPlan: Identifiable, Equatable {
    let id = UUID()
    let username: String
    let map: String
    let shell: String
    let date: Date
    let resources: [String]
    
    static func == (lhs: FriendRunPlan, rhs: FriendRunPlan) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Flow Layout for Tags

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    @Previewable @State var plans = [
        FriendRunPlan(
            username: "Dadcore",
            map: "Perimeter",
            shell: "Vandal",
            date: Date().addingTimeInterval(3600),
            resources: ["Ceramic Plates", "Mk1 Optics", "Titanium Plating", "High-Cap Battery"]
        ),
        FriendRunPlan(
            username: "NateB",
            map: "Dire Marsh",
            shell: "Recon",
            date: Date().addingTimeInterval(7200),
            resources: ["Mk2 CPU", "Fusion Core", "Alien Tech Fragment"]
        )
    ]
    
    RunPlanCardStackView(friendPlans: $plans) { plan in
        print("Accepted plan from \(plan.username)")
    }
}
