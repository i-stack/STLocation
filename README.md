# STLocation

> **A concise CoreLocation-based Swift package** for location fetching, permission management and geocoding — single-shot & continuous updates, smart caching and thread-safe design. Supports Swift Package Manager.

[![License](https://img.shields.io/badge/license-MIT-green?style=flat)](https://github.com/i-stack/STLocation/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%2013%2B-lightgrey?style=flat)](https://github.com/i-stack/STLocation)
[![Swift](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange?style=flat-square)](https://www.swift.org)
[![SPM](https://img.shields.io/badge/SPM-supported-brightgreen?style=flat)](https://github.com/i-stack/STLocation)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-147EFB?style=flat)](https://developer.apple.com/xcode/)

**STLocation** is an open-source **iOS location manager** written in **Swift**, built on `CoreLocation`. It provides single-shot & continuous location updates, intelligent permission requests, automatic geocoding, smart location caching and a complete error-handling model.

STLocation 是一个基于 CoreLocation 的 Swift 位置管理库，提供简洁易用的位置获取、权限管理和地理编码功能。

## 📋 目录 | Table of Contents

- [特性 | Features](#features)
- [系统要求 | Requirements](#requirements)
- [安装方式 | Installation](#installation)
- [权限配置 | Permissions](#permissions)
- [快速开始 | Quick Start](#quick-start)
  - [单次定位](#single)
  - [持续定位](#continuous)
  - [权限请求与检查](#auth)
  - [配置选项](#config)
- [数据结构 | Types](#types)
- [许可证 | License](#license)

<a id="features"></a>
## 🎯 特性 | Features

| 类别 | 能力 |
| --- | --- |
| 定位 | 单次定位、持续位置更新 |
| 权限 | 智能权限请求（使用期间 / 始终）与状态检查 |
| 地理编码 | 自动将坐标转换为地址信息 |
| 缓存 | 智能位置缓存，提高性能、降低请求频率 |
| 配置 | 多种精度、距离过滤与超时配置 |
| 健壮性 | 完善的错误类型与并发队列保证的线程安全 |

<a id="installation"></a>
## 🚀 安装方式 | Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/i-stack/STLocation.git", from: "1.0.0"),
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [.product(name: "STLocation", package: "STLocation")]
    )
]
```

或在 Xcode 中选择 `File ▸ Add Package Dependencies...`，输入 `https://github.com/i-stack/STLocation.git`。

```swift
import STLocation
```

<a id="permissions"></a>
## 🔧 权限配置 | Permissions

在 `Info.plist` 中添加位置权限说明：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>此应用需要访问您的位置以提供基于位置的服务</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>此应用需要访问您的位置以提供基于位置的服务</string>
```

<a id="quick-start"></a>
## ⚡ 快速开始 | Quick Start

<a id="single"></a>
### 单次定位

```swift
STLocationManager.shared.st_getCurrentLocation { result in
    switch result {
    case .success(let info):
        print("地址: \(info.formattedAddress)")
        print("坐标: \(info.coordinateString)")
    case .failure(let error):
        print("获取位置失败: \(error.localizedDescription)")
    }
}
```

<a id="continuous"></a>
### 持续定位

```swift
STLocationManager.shared.st_startUpdatingLocation { result in
    switch result {
    case .success(let info): print("位置更新: \(info.formattedAddress)")
    case .failure(let error): print("位置更新失败: \(error.localizedDescription)")
    }
}

// 停止更新
STLocationManager.shared.st_stopUpdatingLocation()

// 最后已知位置 / 清除缓存
if let last = STLocationManager.shared.st_getLastKnownLocation() {
    print("最后位置: \(last.formattedAddress)")
}
STLocationManager.shared.st_clearLocationCache()
```

<a id="auth"></a>
### 权限请求与检查

```swift
STLocationManager.shared.st_requestWhenInUseAuthorization { status in
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
        print("位置权限已授权")
    case .denied, .restricted:
        print("位置权限被拒绝")
    case .notDetermined:
        print("位置权限未确定")
    @unknown default: break
    }
}

STLocationManager.shared.st_checkLocationPermission { status in
    // 同上处理 status
}
```

<a id="config"></a>
### 配置选项

```swift
// 高精度 / 低精度（省电） / 默认
STLocationManager.shared.st_getCurrentLocation(config: .highAccuracy) { _ in }
STLocationManager.shared.st_getCurrentLocation(config: .lowAccuracy) { _ in }
STLocationManager.shared.st_getCurrentLocation(config: .default) { _ in }

// 自定义
let custom = STLocationConfig(
    desiredAccuracy: kCLLocationAccuracyBest,
    distanceFilter: 5.0,
    timeout: 20.0,
    maximumAge: 180.0
)
STLocationManager.shared.st_getCurrentLocation(config: custom) { _ in }
```

`STLocationConfig` 字段：

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `desiredAccuracy` | `CLLocationAccuracy` | `kCLLocationAccuracyNearestTenMeters` | 期望定位精度 |
| `distanceFilter` | `CLLocationDistance` | `10.0` | 位置更新最小距离（米） |
| `timeout` | `TimeInterval` | `30.0` | 获取位置超时（秒） |
| `maximumAge` | `TimeInterval` | `300.0` | 位置缓存最大有效期（秒） |

<a id="types"></a>
## 🧩 数据结构 | Types

```swift
public struct STLocationInfo {
    public let name: String?
    public let country: String?
    public let latitude: Double
    public let longitude: Double
    public let locality: String?
    public let subLocality: String?
    public let thoroughfare: String?
    public let subThoroughfare: String?
    public let isoCountryCode: String?
    public let administrativeArea: String?
    public let postalCode: String?
    public let timestamp: Date

    public var formattedAddress: String   // 格式化地址
    public var coordinateString: String   // 坐标字符串
}

public enum STLocationError: Error {
    case authorizationDenied
    case authorizationRestricted
    case locationServicesDisabled
    case timeout
    case networkError
    case geocodingFailed
    case unknown(Error)
}
```

<a id="license"></a>
## 📄 许可证 | License

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。

---

**STLocation** — a CoreLocation-based location manager for iOS & Swift. Keywords: *iOS, Swift, CoreLocation, geolocation, geocoding, permission, caching, Swift Package Manager*.
