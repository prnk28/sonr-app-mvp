<p align="center">
<img width="500" src="https://uploads-ssl.webflow.com/60e4b57e5960f8d0456720e7/60fbc0e3804457746c22c731_Github%20-%20App.png">
</p>

*By [Sonr](https://www.sonr.io), creators of [The Sonr App](https://www.twitter.com/TheSonrApp)*

---

Sonr Mobile App Flutter frontend that utilizes [sonr_plugin](https://github.com/sonr-io/plugin) and [namebase](https://github.com/sonr-io/namebase).
Effortlessly Share Files, Sonr is a Decentralized File Sharing Platform that works like Airdrop locally and like Email when you need to share things a bit further.

## 🔷 Installation
Generate **SQL** Table fields by running this command:
```bash
flutter packages pub run build_runner build
```

Wrap **Enviornment Keys** with this command:
```bash
flutter pub get
flutter pub run environment_config:generate --ip_key=$ip_key --rapid_key=$rapid_key --hs_key=$hs_key  --hs_secret=$hs_secret --storj_key=$storj_key --storj_root_password=$storj_root_password --sentry_dsn=$sentry_dsn --hub_key=$hub_key --hub_secret=$hub_secret --map_key=$map_key --map_secret=$map_secret`
```

Generate **Icon Comments** using this command:
```regex
// PCRE (PHP < 7.3)
^.*(\s([a-zA-Z]+\s)+).*$

Substitution: SonrIcons -$2![Icon of $2 ](/Users/prad/Sonr/docs/icons/PNG/$2.png)\n\0\n
```
  * Expression for Comment Generation
  * **DONT** use underscores for fonts

## 🔷 Usage
This project contains a `makefile` with the following commands:
```bash
# Activates Global Flutter Plugins
make activate

# Builds IPA and APB for Sonr App
make build

# Builds IPA ONLY for iOS Sonr App
make build.ios

# Builds APB ONLY for Android Sonr App
make build.android

# Run App for Profiling and Save SKSL File
make profile

# Fetch Plugin Submodule, and Upgrade Dependencies
make update

# Cleans App Build Cache
make clean
```

## 🔷 Type Conversion
Table for **Gomobile** type conversions from bind.
```
| Dart                       | Java                | Kotlin      | Obj-C                                          | Swift                                   |
| -------------------------- | ------------------- | ----------- | ---------------------------------------------- | --------------------------------------- |
| null                       | null                | null        | nil (NSNull when nested)                       | nil                                     |
| bool                       | java.lang.Boolean   | Boolean     | NSNumber numberWithBool:                       | NSNumber(value: Bool)                   |
| int                        | java.lang.Integer   | Int         | NSNumber numberWithInt:                        | NSNumber(value: Int32)                  |
| int, if 32 bits not enough | java.lang.Long      | Long        | NSNumber numberWithLong:                       | NSNumber(value: Int)                    |
| double                     | java.lang.Double    | Double      | NSNumber numberWithDouble:                     | NSNumber(value: Double)                 |
| String                     | java.lang.String    | String      | NSString                                       | String                                  |
| Uint8List                  | byte[]              | ByteArray   | FlutterStandardTypedData typedDataWithBytes:   | FlutterStandardTypedData(bytes: Data)   |
| Int32List                  | int[]               | IntArray    | FlutterStandardTypedData typedDataWithInt32:   | FlutterStandardTypedData(int32: Data)   |
| Int64List                  | long[]              | LongArray   | FlutterStandardTypedData typedDataWithInt64:   | FlutterStandardTypedData(int64: Data)   |
| Float64List                | double[]            | DoubleArray | FlutterStandardTypedData typedDataWithFloat64: | FlutterStandardTypedData(float64: Data) |
| List                       | java.util.ArrayList | List        | NSArray                                        | Array                                   |
| Map                        | java.util.HashMap   | HashMap     | NSDictionary                                   | Dictionary                              |
