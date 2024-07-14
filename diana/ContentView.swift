//
//  ContentView.swift
//  diana
//
//  Created by Isaiah Belenkiy on 7/14/24.
//

import SwiftUI

struct ContentView: View {
    // Create a shared instance of UserSettings
    @StateObject private var userSettings = UserSettings()
    
    var body: some View {
        TabView {
            // Inject userSettings into HomeView
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .environmentObject(userSettings)
            
            // Inject userSettings into ProfileView
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .environmentObject(userSettings)
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var tempUsername: String = ""
    @State private var phoneNumebr: String = ""
    @State private var email: String = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Your Style, Your Profile")
                    .font(.title)
                Image(systemName: "pencil")
                    .foregroundColor(Color(UIColor.systemTeal))
                    .font(.largeTitle)
            }
            HStack {
                Text("Customize Your Experience")
            }

            VStack {
                TextField("Enter username", text: $tempUsername)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Enter email (optional)", text: $phoneNumebr)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Enter phone numebr", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    showingConfirmation = true
                }) {
                    Text("Save")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showingConfirmation) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Do you want to save '\(tempUsername)' as your username?"),
                        primaryButton: .default(Text("Save")) {
                            userSettings.username = tempUsername // Update username in UserSettings
                            saveUsername()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            Spacer()
        }
        .navigationBarTitle("Profile")
        .onAppear {
            // Set tempUsername to current username when view appears
            tempUsername = userSettings.username
        }
    }
    
    func saveUsername() {
        // Example of saving to UserDefaults
        UserDefaults.standard.set(userSettings.username, forKey: "savedUsername")
        // You can add further logic here for handling the saved username
    }
}

struct HomeView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack {
            HStack {
                Text("Stellar Selections")
                    .font(.headline)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow) // Optional: Change color
            }
            Spacer()
            Text("Hey \(userSettings.username), what’s good?")
                .font(.title)
            Spacer()
            HStack {
                Button(action: {
                    // Add action for your button here
                    print("Button tapped")
                }) {
                    Text("Menu")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .navigationBarTitle("Home")
    }
}

class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "savedUsername")
        }
    }
    
    init() {
        self.username = UserDefaults.standard.string(forKey: "savedUsername") ?? ""
    }
}



#Preview {
    ContentView()
//    ProfileView()
}
