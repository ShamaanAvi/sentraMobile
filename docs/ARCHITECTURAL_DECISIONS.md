# Architectural Decisions (PRD over TRD)

This file records requirement conflicts found between [PRD.md](PRD.md) and [TRD.md](TRD.md), with final decisions applied during implementation.

## Decision Rule

When PRD and TRD conflict, PRD is treated as the higher authority.

## Decisions

1. State management
- Conflict: TRD lists Riverpod or Provider.
- Decision: Use Riverpod only.
- Reason: TRD preference and stronger long-term maintainability.

2. WebView stack
- Conflict: TRD names webview_flutter but also recommends flutter_inappwebview.
- Decision: Phase 1 keeps both dependencies available; implementation path uses flutter_inappwebview in later phases.
- Reason: Keeps compatibility while following recommended strategy.

3. Push notifications scope
- Conflict: TRD required package list includes Firebase messaging even though PRD marks push as future-ready.
- Decision: Keep dependency readiness only; no push implementation in Phase 1.
- Reason: PRD phase intent.

4. Deep link format
- Conflict: TRD includes malformed `sentra://https://sentra.airforce.lk/*` format.
- Decision: Support two valid patterns in later implementation:
  - `sentra://...`
  - `https://sentra.airforce.lk/...`
- Reason: PRD wording and valid URI design.

5. Offline UX wording
- Conflict: PRD says offline screen, TRD says offline page.
- Decision: Implement as native offline screen behavior.
- Reason: Equivalent outcome, PRD terminology used as canonical.

6. Download scope
- Conflict: TRD is generic; PRD explicitly names PDF/image handling.
- Decision: Ensure PDF/image support first, then expand if needed.
- Reason: PRD acceptance baseline.

7. Security baseline
- Conflict: TRD security details are less explicit than PRD.
- Decision: Enforce HTTPS-only transport posture, release debugging disabled, and insecure route/mixed-content controls in subsequent WebView phase.
- Reason: PRD FR-013.

## Phase 1 Notes

- Foundation scaffolding completed for clean architecture modules, routing, environment config, constants, and DI via Riverpod.
- Platform baselines aligned for minimum Android SDK 24 and iOS deployment target 14.
- Full Android/iOS artifact builds cannot be executed in current local environment due missing Android SDK and a Flutter installation without iOS build target support.
