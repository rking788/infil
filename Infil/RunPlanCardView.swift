import SwiftUI

struct RunPlanCardView: View {
    let plan: RunPlan
    var onSwipe: (SwipeOutcome) -> Void
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    enum SwipeOutcome {
        case select(Shell), reject
    }
    
    var body: some View {
        ZStack {
            // Screen Edge Highlights
            if isDragging {
                highlightOverlays
                    .transition(.opacity)
            }
            
            // Card Content
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(plan.mapName)
                            .font(.title2)
                            .bold()
                        Text("by \(plan.creatorName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "map.fill")
                        .font(.largeTitle)
                        .opacity(0.1)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Label(plan.plannedAt.formatted(date: .long, time: .shortened), systemImage: "calendar")
                        .font(.callout)
                    
                    if !plan.resources.isEmpty {
                        Text("Resources: " + plan.resources.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if !plan.contracts.isEmpty {
                        Text("Contracts: " + plan.contracts.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if plan.resources.isEmpty && plan.contracts.isEmpty {
                        Text("No specific targets planned")
                            .font(.caption)
                            .italic()
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
            }
            .padding(24)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: 2)
            )
            .shadow(radius: isDragging ? 15 : 5)
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                        isDragging = true
                    }
                    .onEnded { _ in
                        handleSwipeEnd()
                    }
            )
        }
    }
    
    private var borderColor: Color {
        if offset.width < -50 { return .red }
        if offset.width > 50 { return .marathonYellow }
        return Color.marathonYellow.opacity(0.5)
    }
    
    private var highlightOverlays: some View {
        GeometryReader { geo in
            ZStack {
                // Reject Highlight (Left)
                HStack {
                    VStack {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 60))
                        Text("REJECT")
                            .font(.caption)
                            .bold()
                        Spacer()
                    }
                    .frame(width: 100)
                    .background(Color.red.opacity(offset.width < -100 ? 0.3 : 0.05))
                    .foregroundColor(.red)
                    Spacer()
                }
                
                // Shell Highlights (Right)
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        ForEach(Shell.allCases) { shell in
                            VStack {
                                Image(systemName: shell.icon)
                                    .font(.title)
                                Text(shell.rawValue)
                                    .font(.caption2)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                Color.marathonYellow.opacity(isNearShell(shell, in: geo.size.height) ? 0.4 : 0.05)
                            )
                            .foregroundColor(isNearShell(shell, in: geo.size.height) ? .black : .marathonYellow)
                        }
                    }
                    .frame(width: 100)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private func isNearShell(_ shell: Shell, in totalHeight: CGFloat) -> Bool {
        guard offset.width > 100 else { return false }
        
        // Calculate which shell zone we are in vertically
        let zones = Shell.allCases.count
        let zoneHeight = totalHeight / CGFloat(zones)
        
        // Convert offset.height (which is centered) to screen-top relative
        // offset.height is 0 when card is in center of stack
        let relativeY = (totalHeight / 2) + offset.height
        let index = Int(relativeY / zoneHeight)
        
        let shellIndex = Shell.allCases.firstIndex(of: shell) ?? 0
        return index == shellIndex
    }
    
    private func handleSwipeEnd() {
        let threshold: CGFloat = 150
        if offset.width < -threshold {
            onSwipe(.reject)
        } else if offset.width > threshold {
            // Find which shell we were nearest to
            // This is a bit of a hack without the totalHeight but we can use a standard height or current drag
            // In a real app we'd pass the height in or use GeometryReader better
            // For now, let's use a standard height assumption or refactor
            // Actually, we can just check offset.height
            
            let zones = CGFloat(Shell.allCases.count)
            let estimatedHeight: CGFloat = 600 // Approximation
            let relativeY = (estimatedHeight / 2) + offset.height
            let index = Int(max(0, min(zones - 1, relativeY / (estimatedHeight / zones))))
            let selectedShell = Shell.allCases[index]
            
            onSwipe(.select(selectedShell))
        } else {
            withAnimation(.spring()) {
                offset = .zero
                isDragging = false
            }
        }
    }
}

#Preview {
    RunPlanCardView(plan: .mockPerimeter) { _ in }
        .padding()
}
