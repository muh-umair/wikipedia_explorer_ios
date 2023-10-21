import Foundation

/// Different errors thrown by ``NetworkService``
public enum NetworkServiceError: Error, LocalizedError {
    case undefined
    case failedDecoding
    case timeout
    case noNetwork
    case noMockFound
    case failedMockLoading
    case invalidRequest
    case invalidResponse
    
    /// Localized description of error
    public var errorDescription: String? {
        switch self {
        case .undefined: return L10n.network_error_undefined.localized
        case .failedDecoding: return L10n.network_error_failed_decoding.localized
        case .timeout: return L10n.network_error_timeout.localized
        case .noNetwork: return L10n.network_error_no_network.localized
        case .noMockFound: return L10n.network_error_no_mock.localized
        case .failedMockLoading: return L10n.network_error_failed_mock_loading.localized
        case .invalidRequest: return L10n.network_error_invalid_request.localized
        case .invalidResponse: return L10n.network_error_invalid_response.localized
        }
    }
}

extension NetworkServiceError {
    /// Convert normal error to ``NetworkServiceError``
    init(error: Error?) {
        switch error?._code {
        case NSURLErrorTimedOut:
            self = .timeout
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            self = .noNetwork
        default:
            self = .undefined
        }
    }
}
