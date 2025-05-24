//
//  WebViewScreen.swift
//  FakeNFT
//
//  Created by Kaider on 24.05.2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    init(url: URL, isLoading: Binding<Bool> = .constant(false)) {
        self.url = url
        self._isLoading = isLoading
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}

struct WebViewScreen: View {
    let url: URL
    @State var isLoading = false

    var body: some View {
        ZStack {
            WebView(url: url, isLoading: $isLoading)
            if isLoading {
                ProgressView("Загрузка...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .navigationTitle("Веб-страница")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WebViewScreen(url: URL(string: "https://yandex.ru/legal/practicum_termsofuse/")!)
    }
}
