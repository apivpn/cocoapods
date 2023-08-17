//
//  ApiVPN.swift
//  ApiVPN
//
//  Created by Eric on 2022/11/23.
//

import Foundation
import NetworkExtension
import apivpncore

public enum ApiVpnError: Error {
    case TunFileDescriptorNotFound
    case InvalidJSONObject
    case CacheDirError
    case Unknown
    // apivpncore errors
    case Internal
    case Network
    case Serialization
    case VpnStart
    case NotInitialized
    case WriteMetadata
}

extension ApiVpnError {
    static func from_errno(_ errno: Int32) -> ApiVpnError {
        switch errno {
        case 1:
            return .Internal
        case 2:
            return .Network
        case 3:
            return .Serialization
        case 4:
            return .VpnStart
        case 5:
            return .NotInitialized
        case 6:
            return .WriteMetadata
        default:
            return .Unknown
        }
    }
}

public typealias VpnInitCompletionHandler = (ApiVpnError?) -> Void
public typealias ServersCompletionHandler = (Servers?, ApiVpnError?) -> Void
public typealias StartV2RayCompletionHandler = (ApiVpnError?) -> Void
public typealias ConnectionLogFileCompletionHandler = (String?, ApiVpnError?) -> Void

public struct Country: Decodable {
    public let code: String
    public let name: String
}

public struct Server: Decodable {
    public let id: Int32
    public let ip: String
    public let exit: String
    public let name: String
    public let icon: String?
    public let hostname: String
    public let location: String
    public let latitude: Double
    public let longitude: Double
    public let premium: Bool
    public let country: Country
    public let sort: Int32
    public let pin: Bool
    public let group_id: Int32?
}

public typealias Servers = [Server]

public class ApiVpn {
    public static let shared: ApiVpn = {
        return ApiVpn()
    }()
    
    private var tunnelFileDescriptor: Int32? {
        var buf = [CChar](repeating: 0, count: Int(IFNAMSIZ))
        for fd: Int32 in 0...1024 {
            var len = socklen_t(buf.count)
            if getsockopt(fd, 2, 2, &buf, &len) == 0 && String(cString: buf).hasPrefix("utun") {
                return fd
            }
        }
        return nil
    }
    
    public func initialize(_ appToken: String, _ apiServer: String, _ dataDir: String, _ completionHandler: @escaping VpnInitCompletionHandler) {
        let bundle = Bundle(for: Self.self)
        let bundlePath = bundle.resourcePath!
        setenv("LOG_CONSOLE_OUT", "true", 1)
        setenv("ASSET_LOCATION", bundlePath, 1)
        setenv("SSL_CERT_DIR", bundlePath, 1)
        setenv("SSL_CERT_FILE", bundle.path(forResource: "cacert", ofType: ".pem"), 1)

        DispatchQueue.global().async {
            let err = apivpn_init(appToken, apiServer, dataDir)
            if err == 0 {
                completionHandler(nil)
            } else {
                completionHandler(ApiVpnError.from_errno(err))
            }
        }
    }
    
    public func servers(_ completionHandler: @escaping ServersCompletionHandler) {
        DispatchQueue.global().async {
            let ptr = apivpn_servers()
            if let ptr = ptr {
                let serialized = String(cString: ptr)
                apivpn_servers_free(ptr)
                do {
                    if let jsonData = serialized.data(using: .utf8) {
                        let servers = try JSONDecoder().decode(Servers.self, from: jsonData)
                        completionHandler(servers, nil)
                    } else {
                        completionHandler(nil, ApiVpnError.InvalidJSONObject)
                    }
                } catch {
                    completionHandler(nil, ApiVpnError.InvalidJSONObject)
                }
            } else {
                completionHandler(nil, ApiVpnError.from_errno(apivpn_last_error()))
            }
        }
    }
    
    public func connection_log_file(_ completionHandler: @escaping ConnectionLogFileCompletionHandler) {
        DispatchQueue.global().async {
            let ptr = apivpn_get_connection_log_file()
            if let ptr = ptr {
                let path = String(cString: ptr)
                apivpn_servers_free(ptr)
                completionHandler(path, nil)
            } else {
                completionHandler(nil, ApiVpnError.from_errno(apivpn_last_error()))
            }
        }
    }
    
    public func start_v2ray(_ server_id: Int32, _ packetFlow: NEPacketTunnelFlow, _ altRules: String, _ completionHandler: @escaping StartV2RayCompletionHandler) {
        guard let fd = tunnelFileDescriptor else {
            completionHandler(ApiVpnError.TunFileDescriptorNotFound)
            return
        }
        let err = apivpn_start_v2ray(server_id, fd, altRules)
        if err == 0 {
            completionHandler(nil)
        } else {
            completionHandler(ApiVpnError.from_errno(err))
        }
    }
    
    public func stop() {
        apivpn_stop()
    }
    
    public func is_running() -> Bool {
        return apivpn_is_running()
    }
}
