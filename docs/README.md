# SENTRA Mobile

Production-grade Flutter mobile shell for the existing SENTRA web platform:

- Production URL: https://sentra.airforce.lk
- Frontend/backend remain in existing web stack (Next.js/Laravel).
- Mobile app provides native UX, security guardrails, file handling, and external URL handoff.

## Implemented Highlights

- Clean architecture scaffold under `lib/core`, `lib/features`, and `lib/shared`.
- Riverpod-based dependency composition and state management.
- `flutter_inappwebview` host with:
	- HTTPS-only and internal-host navigation policy
	- External URL native handoff via `url_launcher`
	- Pull-to-refresh, Android back behavior, and exit confirmation
	- Loading, offline, error, and retry UX states
- File handling foundation:
	- Download start interception
	- Save file to app documents storage
	- Native open-file handoff
- Security hardening:
	- Mixed-content blocking
	- WebView debug disabled outside debug mode
	- Server trust challenge cancellation

## Local Development

1. Install Flutter stable and Android/iOS toolchains.
2. Run dependency install:

```bash
flutter pub get
```

3. Run quality checks:

```bash
flutter analyze
flutter test
```

4. Build Android release artifact:

```bash
flutter build apk --release
```

For Play Store release signing, create `android/key.properties` (not committed) with:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=../path/to/your-release-key.jks
```

If `android/key.properties` is present, Gradle uses that release signing config.
If it is absent, local release builds fall back to debug signing only.

## Android Build Requirements

- Android SDK Platform 35 installed.
- Android Build-Tools for API 35 installed.
- Java 17 configured for Gradle.
- `ANDROID_HOME` or `ANDROID_SDK_ROOT` points to the local Android SDK.

If you see `JdkImageTransform` errors referencing `android-34/core-for-system-modules.jar`, install/update SDK Platform 35 and ensure Gradle is using Java 17.

Run preflight before local release builds:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/android-preflight.ps1
```

## CI

GitHub Actions workflow is available at `.github/workflows/flutter_ci.yml`.
It runs:

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --release`
- `flutter build appbundle --release`
- `flutter build ios --no-codesign` (macOS runner)

## Notes

- Deep-link runtime package integration is temporarily stubbed due toolchain/package compatibility constraints and is documented in `docs/ARCHITECTURAL_DECISIONS.md`.
- Store readiness checklist: `docs/STORE_READINESS_CHECKLIST.md`.
