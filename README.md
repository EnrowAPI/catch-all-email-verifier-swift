# Catch-All Email Verifier - Swift Library

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Verify emails on catch-all domains with deterministic verification. Most verifiers mark catch-all emails as "risky" or "unknown" -- this one tells you if the specific mailbox actually exists.

Powered by [Enrow](https://enrow.io) -- deterministic email verification, not probabilistic.

## The catch-all problem

A catch-all (or accept-all) domain is configured to accept mail sent to any address at that domain, whether or not the specific mailbox exists. This means `anything@company.com` will not bounce at the SMTP level, so traditional email verifiers cannot distinguish real inboxes from non-existent ones. They return "accept-all", "risky", or "unknown" and leave you guessing.

Enrow uses deterministic verification techniques that go beyond SMTP handshake checks, resolving the actual mailbox existence on catch-all domains. The result is a clear valid/invalid verdict instead of an inconclusive shrug.

## Installation

Add the package with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/enrow/catch-all-email-verifier-swift", from: "1.0.0"),
]
```

Requires Swift 5.9+. Zero dependencies -- uses only Foundation `URLSession`.

## Simple Usage

```swift
import CatchAllEmailVerifier

let verification = try await CatchAllVerifier.verify(
    apiKey: "your_api_key",
    email: "tcook@apple.com"
)

let result = try await CatchAllVerifier.getResult(apiKey: "your_api_key", id: verification.id)

print(result.email)         // tcook@apple.com
print(result.qualification) // valid
```

`verify` returns a verification ID. The verification runs asynchronously on the server -- call `getResult` to retrieve the result once it is ready. You can also pass a `webhook` URL to get notified automatically.

## Bulk verification

```swift
let batch = try await CatchAllVerifier.verifyBulk(
    apiKey: "your_api_key",
    verifications: [
        BulkVerification(email: "tcook@apple.com"),
        BulkVerification(email: "satya@microsoft.com"),
        BulkVerification(email: "jensen@nvidia.com"),
    ]
)

// batch.batchId, batch.total, batch.status

let results = try await CatchAllVerifier.getBulkResults(apiKey: "your_api_key", id: batch.batchId)
// results.results -- array of VerificationResult
```

Up to 5,000 verifications per batch. Pass a `webhook` URL to get notified when the batch completes.

## Error handling

```swift
do {
    let _ = try await CatchAllVerifier.verify(
        apiKey: "bad_key",
        email: "test@test.com"
    )
} catch let error as CatchAllVerifierError {
    print(error.statusCode) // HTTP status code
    print(error.message)    // API error description
    // Common errors:
    // - "Invalid or missing API key" (401)
    // - "Your credit balance is insufficient." (402)
    // - "Rate limit exceeded" (429)
}
```

## Getting an API key

Register at [app.enrow.io](https://app.enrow.io) to get your API key. You get **50 free credits** (= 200 verifications) with no credit card required. Each verification costs **0.25 credits**.

Paid plans start at **$17/mo** for 1,000 credits up to **$497/mo** for 100,000 credits. See [pricing](https://enrow.io/pricing).

## Documentation

- [Enrow API documentation](https://docs.enrow.io)
- [Full Enrow SDK](https://github.com/enrow/enrow-swift) -- includes email finder, phone finder, reverse email lookup, and more

## License

MIT -- see [LICENSE](LICENSE) for details.
