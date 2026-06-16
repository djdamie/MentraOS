import Foundation

/// Defaults for the public Bluetooth SDK surface.
enum BluetoothSdkDefaults {
    private static let compiledSdkVersion = "0.1.12"

    static var sdkVersion: String? {
        packageVersion(from: sdkBundle) ?? compiledSdkVersion
    }

    static let voiceActivityDetectionEnabled = false

    private static var sdkBundle: Bundle {
        #if SWIFT_PACKAGE
            Bundle.module
        #else
            Bundle(for: BluetoothSdkBundleToken.self)
        #endif
    }

    private static func packageVersion(from bundle: Bundle) -> String? {
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        for candidate in [version, build] {
            if let candidate, !candidate.isEmpty, candidate != "1.0" {
                return candidate
            }
        }

        return nil
    }
}

private final class BluetoothSdkBundleToken {}
