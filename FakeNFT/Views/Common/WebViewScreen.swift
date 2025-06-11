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
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url == nil || webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        private var loadingTimer: Timer?
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        deinit {
            loadingTimer?.invalidate()
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
                self.startLoadingTimer()
            }
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            // Скрываем ProgressHUD сразу после подтверждения загрузки основной страницы
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.stopLoadingTimer()
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.stopLoadingTimer()
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.stopLoadingTimer()
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            let nsError = error as NSError
            
            DispatchQueue.main.async {
                if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.parent.isLoading = false
                    }
                } else {
                    self.parent.isLoading = false
                }
                self.stopLoadingTimer()
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                let urlString = url.absoluteString
                // Блокируем сторонние запросы для ускорения загрузки, и скрытия progressHUD
                if urlString.contains("yandex.net/analytics") ||
                   urlString.contains("pixels.praktikum.yandex.net") ||
                   urlString.contains("mc.yandex.com/metrika") {
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
        private func startLoadingTimer() {
            stopLoadingTimer()
            loadingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
            }
        }
        
        private func stopLoadingTimer() {
            loadingTimer?.invalidate()
            loadingTimer = nil
        }
    }
}

struct WebViewScreen: View {
    let url: URL
    @State private var isLoading = false
    @State private var hasAppeared = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            WebView(url: url, isLoading: $isLoading)
                .progressHUD(isLoading: isLoading)
        }
        .navigationBarStyle(dismissAction: { dismiss() })
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !hasAppeared {
                isLoading = true
                hasAppeared = true
            }
        }
        .onDisappear {
            isLoading = false
            hasAppeared = false
        }
        .id(url.absoluteString)
    }
}

#Preview {
    NavigationStack {
        WebViewScreen(url: URL(string: "https://yandex.ru/legal/practicum_termsofuse/")!)
    }
}
