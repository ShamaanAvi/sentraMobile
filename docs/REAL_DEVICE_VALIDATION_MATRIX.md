# Real-Device Validation Matrix

This matrix covers required real-device validation for uploads, downloads, and external URL handoff.

## Test Scope

- Platforms: Android (API 24+), iOS (14+)
- Core features:
  - File uploads (camera, gallery, files, PDF, images)
  - File downloads (save + open)
  - External URL handoff (`mailto:`, `tel:`, `sms:`, `whatsapp:`, maps, YouTube, external websites)

## Device Matrix

| Platform | Device | OS Version | Build | Status | Evidence |
|---|---|---|---|---|---|
| Android | Pixel 6 | Android 14 | app-release.apk | Pending | - |
| Android | Samsung A54 | Android 13 | app-release.apk | Pending | - |
| iOS | iPhone 13 | iOS 17 | TestFlight build | Pending | - |
| iOS | iPhone SE (2nd) | iOS 16 | TestFlight build | Pending | - |

## Upload Validation

| ID | Scenario | Android | iOS | Result Notes |
|---|---|---|---|---|
| U-01 | Upload image from gallery | Pending | Pending | |
| U-02 | Capture photo via camera and upload | Pending | Pending | |
| U-03 | Upload PDF via picker | Pending | Pending | |
| U-04 | Upload generic file via picker | Pending | Pending | |
| U-05 | Permission denied flow and retry | Pending | Pending | |

## Download Validation

| ID | Scenario | Android | iOS | Result Notes |
|---|---|---|---|---|
| D-01 | Download PDF from internal HTTPS URL | Pending | Pending | |
| D-02 | Download image from internal HTTPS URL | Pending | Pending | |
| D-03 | Open downloaded file from in-app action | Pending | Pending | |
| D-04 | Block untrusted/insecure download source | Pending | Pending | |

## External URL Handoff Validation

| ID | URL Type | Android | iOS | Result Notes |
|---|---|---|---|---|
| X-01 | `mailto:` | Pending | Pending | |
| X-02 | `tel:` | Pending | Pending | |
| X-03 | `sms:` | Pending | Pending | |
| X-04 | `whatsapp:` | Pending | Pending | |
| X-05 | maps link | Pending | Pending | |
| X-06 | YouTube link | Pending | Pending | |
| X-07 | External HTTPS website | Pending | Pending | |
| X-08 | Internal `https://sentra.airforce.lk/*` stays in WebView | Pending | Pending | |

## Exit Criteria

- All matrix entries marked Pass on at least one modern Android device and one modern iOS device.
- Any failures linked to issue IDs with mitigation or acceptance decision.
- Evidence captured as screenshots/video and attached to release ticket.
