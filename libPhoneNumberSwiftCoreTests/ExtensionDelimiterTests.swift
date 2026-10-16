import Testing
import libPhoneNumber

/// Preserving Daylite's extension labels must not restrict upstream's expanded extension parser.
@Suite("Marketcircle extension delimiters")
struct ExtensionDelimiterTests {
    /// Explicit and autodial labels retain the longer extensions accepted by current upstream metadata.
    @Test("Preserve labels with current upstream extension limits", arguments: [
        (" ext. ", "12345678901234567890"),
        (" доб. ", "12345678901234567890"),
        (";", "123456789012345"),
        (",,", "123456789012345"),
        (",", "123456789"),
        (" x", "123456789"),
    ])
    func preserveExpandedExtensions(sample: (String, String)) throws {
        let util = NBPhoneNumberUtil.sharedInstance()
        let (label, digits) = sample
        let number = try util.parseAndKeepRawInput("6502530000" + label + digits, defaultRegion: "US")
        #expect(number.extension == digits)
        #expect(number.extensionDelimiter == label)
        #expect(try util.format(number, numberFormat: .NATIONAL, preserveExtensionDelimiter: true)
            == "(650) 253-0000" + label + digits)
    }

    /// RFC3966 always uses its wire syntax, regardless of the user's extension label.
    @Test("RFC3966 formatting ignores a preserved label")
    func rfc3966UsesStandardSyntax() throws {
        let util = NBPhoneNumberUtil.sharedInstance()
        let number = try util.parseAndKeepRawInput("6502530000 ext. 123", defaultRegion: "US")
        #expect(try util.format(number, numberFormat: .RFC3966, preserveExtensionDelimiter: true)
            == "tel:+1-650-253-0000;ext=123")
    }

    /// Copying a parsed number must retain the label used by Daylite's storage and display formatters.
    @Test("Copy retains the normalized extension delimiter")
    func copyRetainsDelimiter() throws {
        let util = NBPhoneNumberUtil.sharedInstance()
        let original = try util.parseAndKeepRawInput("6502530000,\tX123", defaultRegion: "US")
        let copy = try #require(original.copy() as? NBPhoneNumber)
        #expect(copy.extensionDelimiter == ", x")
        #expect(try util.format(copy, numberFormat: .NATIONAL, preserveExtensionDelimiter: true)
            == "(650) 253-0000, x123")
    }
}
