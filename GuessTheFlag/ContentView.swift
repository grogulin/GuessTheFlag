//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ярослав Грогуль on 16.12.2022.
//

import SwiftUI


struct Title: ViewModifier {
    func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
}

extension View {
    func titleModifier() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Monaco", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var animateGradient = false
    
    @State private var currentRound = 1
    
    func FlagImage(_ image: String) -> some View {
        let imageView = Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
        return imageView
    }
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: .leading, endPoint: .trailing)
            LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: animateGradient ? .leading : .center, endPoint: animateGradient ? .center : .bottomTrailing)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            
            
            
            VStack {
                Spacer()
                Text("Guess the Flag!")
                    .titleModifier()
                Text("Round \(currentRound) of 8")
                    .font(.title.weight(.light))
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.headline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.light))
                    }
                    
                    ForEach(0..<3) {number in
                        Button {
                            //flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                Spacer()
                Spacer()
                Text("Score: \(currentScore)")
                    .foregroundColor(.white)
                    .font(.title.weight(.bold))
                Spacer()
            }
            .padding(20)
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(currentRound < 8 ? "Continue" : "Sure!", action: askQuestion)
        } message: {
            Text(currentRound < 8 ? "Your score is \(currentScore)" : "Your final score is \(currentScore) out of 8. Try again?")
        }
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong, this is a flag of \(countries[number])"
        currentScore = number == correctAnswer ? currentScore + 1 : 0
        showingScore = true
    }
    
    func askQuestion() {
        if currentRound<8 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            currentRound += 1
        } else {
            currentScore = 0
            currentRound = 1
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
