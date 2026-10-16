# Marketcircle fork

Daylite consumes the `extension-delimiter` branch of Marketcircle/libPhoneNumber-iOS.
APP-2001 updates the fork from `5aa4222` to upstream release **2.1.2**, commit
`85d5486deb600fd6c5d56c908d5966d2daf88968` (Google libphonenumber metadata v9.0.41).

## Intentional differences from upstream

- The default extension prefix is ` x` instead of ` ext. `, unless regional
  metadata supplies a preferred prefix.
- `NBPhoneNumber.extensionDelimiter` records the parsed label. Copies retain it.
- `format:numberFormat:preserveExtensionDelimiter:error:` optionally retains that
  label. Consecutive whitespace collapses to one space; `X` becomes `x`, and an
  `x` or fullwidth `ｘ` label always has a preceding space.
- RFC3966 output always uses `;ext=`. RFC3966 input and American suffix-only
  extensions use the default label when formatted nationally or internationally.

The preservation logic reads the text before the extension digits captured by
upstream's parser. It does not replace upstream's extension patterns or length
limits. Current upstream already accepts comma and semicolon labels, so the
fork's older regex overrides are no longer needed. No generated metadata was
edited manually.

## Daylite integration

The product name remains `libPhoneNumber`; Daylite's formatting implementation
compiles against the updated fork. Upstream now declares
`NBPhoneNumberUtil.sharedInstance()` non-optional, so remove the obsolete `!`
in `Frameworks/MCFoundation/PhoneNumberFormattingTests.swift` when integrating
this update into Daylite.

For isolated compatibility validation, copy `PhoneNumberFormatting.swift` into
an `MCFoundation` SwiftPM target and `PhoneNumberFormattingTests.swift` into its
test target. Give both targets a dependency on this checkout's `libPhoneNumber`
product, use Swift 5 language mode, and remove only that obsolete force unwrap
from the copied test file. This exercises Daylite's existing tests without
changing its checkout or package resolution.

## Validation

- `swift test`: package XCTest and Swift Testing suites passed, including the
  existing fork tests and new tests for longer extensions and delimiter copies.
- Isolated Daylite compatibility harness: all 21 existing tests passed.
- Test-name and API parity against Google v9.0.41 passed.
- Version consistency check passed for 2.1.2.
- Fork changes pass whitespace checks against 2.1.2; the imported release retains
  its existing whitespace warnings when compared with the old fork.
- `swift build -c release`: passed on Apple Silicon.
- `swift build -c release --arch x86_64 --target libPhoneNumber`: passed; no Intel execution.
- `LC_ALL=ko_KR.UTF-8 LANG=ko_KR.UTF-8 swift test`: passed.
- Xcode core scheme on iOS Simulator: 151 tests passed, no failures. Xcode also
  reports the performance-test class itself with no result.

This is dependency maintenance. It has **not** established that APP-2001 is fixed
on Intel hardware. No Rosetta installation or Intel execution was performed.
