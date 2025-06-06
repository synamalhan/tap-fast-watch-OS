import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 5
    @State private var gameStarted = false
    @State private var gameOver = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 10) {
            if gameOver {
                Text("⏱ Time's up!")
                Text("Score: \(score)")
                    .font(.title2)
                    .foregroundColor(.green)

                Button("Play Again") {
                    startGame()
                }
            } else {
                Text("Time: \(timeRemaining)")
                    .font(.headline)

                Circle()
                    .fill(Color.purple)
                    .frame(width: 60, height: 60)
                    .overlay(Text("\(score)").foregroundColor(.white))
                    .onTapGesture {
                        if gameStarted {
                            score += 1
                            WKInterfaceDevice.current().play(.click)
                        }
                    }
            }
        }
        .onAppear {
            startGame()
        }
    }

    func startGame() {
        score = 0
        timeRemaining = 5
        gameOver = false
        gameStarted = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            timeRemaining -= 1
            if timeRemaining <= 0 {
                t.invalidate()
                gameStarted = false
                gameOver = true
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }
}
