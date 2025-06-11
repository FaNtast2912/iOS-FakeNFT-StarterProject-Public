import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.ypRedUniversal)
            
            Text("Ошибка загрузки")
                .font(.headline)
                .foregroundColor(.ypBlackUniversal)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.ypGreyUniversal)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Попробовать снова") {
                onRetry()
            }
            .foregroundColor(.ypBlueUniversal)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.ypBlueUniversal.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
    }
}
