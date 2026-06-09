# Store Readiness Checklist

This checklist tracks Google Play and App Store submission readiness for SENTRA Mobile.

## Android

- [ ] Confirm Android SDK Platform 35 is installed in build environment.
- [ ] Confirm Java 17 is used by Gradle build.
- [ ] Confirm app signing uses release keystore (not debug key).
- [ ] Confirm `android/key.properties` exists only in secure local/CI secrets context and is not committed.
- [ ] Confirm release keystore path and alias resolve in CI and local release builds.
- [ ] Confirm `android:debuggable` is disabled for release builds.
- [ ] Confirm declared permissions are limited to required capabilities.
- [ ] Verify external URL handoff for `mailto:`, `tel:`, `sms:`, maps, YouTube, and external websites.
- [ ] Verify internal `https://sentra.airforce.lk/*` URLs remain inside WebView.
- [ ] Upload AAB to internal testing and resolve Play Console warnings.

## iOS

- [ ] Confirm ATS remains enabled and app uses HTTPS only.
- [ ] Verify Camera, Photo Library, and Microphone usage descriptions are accurate.
- [ ] Verify external URL handoff behavior for supported schemes.
- [ ] Validate app behavior on iOS 14+ devices.
- [ ] Archive and upload build in Xcode Organizer.

## Privacy and Compliance

- [ ] Add production privacy policy URL in store metadata.
- [ ] Complete App Privacy details in App Store Connect.
- [ ] Complete Data Safety form in Google Play Console.
- [ ] Confirm no hardcoded secrets in app source.

## Prepared Artifacts

- [x] Real-device validation matrix prepared: `docs/REAL_DEVICE_VALIDATION_MATRIX.md`
- [x] Google Play listing draft prepared: `docs/store/google_play_listing.md`
- [x] App Store listing draft prepared: `docs/store/app_store_listing.md`
- [x] Privacy submission draft prepared: `docs/store/privacy_submission.md`
- [x] Signed iOS archive CI workflow prepared: `.github/workflows/ios_release_signed.yml`

## Functional Release Gate

- [ ] Login and session persistence validated.
- [ ] Upload and download flows validated on real devices.
- [ ] Offline handling and retry flow validated.
- [ ] No analyzer issues and no failing tests.
