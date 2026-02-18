import UIKit
import WebKit

final class RemoteContentViewController: UIViewController {
    private var contentView: WKWebView!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let loadingContainer = UIView()
    private var isInitialLoad = true
    private let contentLink: String
    
    init(link: String) {
        self.contentLink = link
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        setupLoadingView()
        loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOrientationSupport()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func updateOrientationSupport() {
        guard let windowScene = view.window?.windowScene else { return }
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .all)
        windowScene.requestGeometryUpdate(geometryPreferences) { _ in }
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    private func setupContentView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        contentView = WKWebView(frame: .zero, configuration: config)
        contentView.navigationDelegate = self
        contentView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.allowsBackForwardNavigationGestures = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isOpaque = false
        contentView.backgroundColor = .black
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadingView() {
        loadingContainer.backgroundColor = .black
        loadingContainer.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        
        loadingContainer.addSubview(loadingIndicator)
        view.addSubview(loadingContainer)
        
        NSLayoutConstraint.activate([
            loadingContainer.topAnchor.constraint(equalTo: view.topAnchor),
            loadingContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor)
        ])
    }
    
    private func loadContent() {
        guard let address = URL(string: contentLink) else { return }
        var request = URLRequest(url: address)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        contentView.load(request)
    }
    
    private func hideLoadingIfNeeded() {
        guard isInitialLoad else { return }
        isInitialLoad = false
        UIView.animate(withDuration: 0.3) {
            self.loadingContainer.alpha = 0
        } completion: { _ in
            self.loadingContainer.isHidden = true
        }
    }
}

extension RemoteContentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingIfNeeded()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoadingIfNeeded()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
