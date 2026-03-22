//
//  ProfileView.swift
//  Infil
//
//  Created by Rob King on 3/22/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Profile Image
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundStyle(Color.marathonPrimary)
                .shadow(color: Color.marathonPrimary.opacity(0.5), radius: 20)
            
            // Username
            Text("rking788")
                .font(MarathonFontStyle.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.marathonTextPrimary)
            
            Spacer()
        }
        .padding(.top, 40)
        .marathonBackground()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .marathonNavigationBar()
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
