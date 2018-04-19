---
title: "Control Origin Security Context"
date: 2018-04-18T20:59:55+02:00
---

## Summary

Distributed protocols require additional controls for how Origin-based security
context is defined.  Every content root identified by means of
cryptographically-safe hash should have its own Origin and be marked as a
Secure Context.

## Motivation

Current web application security model relies on the concept of [same-origin
policy](https://en.wikipedia.org/wiki/Same-origin_policy). 
[RFC 6454](https://tools.ietf.org/html/rfc6454) defines the "Origin" of a URI as the triple `{protocol, host, port}`.
Two resources are of the same Origin if all values from the triple are the same.

Web pages of different Origins are isolated from each other. Guarantees
provided by this security perimeter enable web app developers to safely store
site-specific data (local storage, cookies) and secrets (session cookies,
access tokens) on user's machine.

**Problem:** In the distributed world a location (host and port) is no longer
relevant. Resources are _content-addressed_ and location authority is
superseded by cryptographically-safe Content Identifiers (CIDs).

The only reliable way to work around this is to create artificial subdomains
for hostname-safe HTTP content addressing using cryptographic hashes (eg.
[HSHCA](https://github.com/neocities/hshca)). A subdomain provides a separate
Origin which creates an isolated security context.  Unfortunately, this
approach obfuscates canonical representations of content-addressing and is not
feasible for local p2p services listening on `127.0.0.1`.

Historically, same-origin policies were extended to define roughly compatible
security boundaries for other web technologies, such as Silverlight, Adobe
Flash, or Adobe Acrobat.  We aim to do the same for distributed web.


## Usage Documentation


### Programmable Origin

[Programmable Custom Protocol Handlers](/programmable-custom-protocol-handlers)
should allow a WebExtension to register itself as the handler for new protocols
in a way that enables controlled creation of Origin that reflects
content-adressing nature of distributed web. Namely, every content root
identified by means of cryptographically-safe hash should have its own Origin.

Section 3.2 of [RFC 3986](https://tools.ietf.org/html/rfc3986) describes a
special case of URI without an authority component and suggests that an opaque
string can be used as a globally unique identifier as/instead of location-based
authority.


### Suborigins for HTTP gateways


Suborigins are a
[work-in-progress](https://w3c.github.io/webappsec-suborigins/) standard to
provide a new mechanism for allowing sites to separate their content by
creating synthetic origins while serving content from a single physical origin.


This feature is especially relevant for HTTP gateways which expose distributed
web within a legacy location-based address space, making it avaiable to regular
web browsers today.  Suborigins would enable backward-compatible isolation
between different content-addressed roots:

    https://<gateway-host>/ipfs/<hash-A>/foo
    https://<gateway-host>/ipfs/<hash-B>/bar/buzz

Without Suborigins, a single Origin of `<gateway-host>` is shared by all sites loaded
from it, making it impossible to write secure web apps that are
backwards-compatible with the legacy HTTP stack.


### Content-addressed resources as Secure Contexts

Some of browser vendors [pledged](https://blog.mozilla.org/security/2018/01/15/secure-contexts-everywhere/) to require secure contexts for all new features.

> A secure context is a `Window` or `Worker` for which there is reasonable
confidence that the content has been delivered securely  (via HTTPS/TLS) [..]
The primary goal of secure contexts is to prevent man-in-the-middle attackers
from accessing powerful APIs that could further compromise the victim of an
attack.  – [MDN web docs](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts)


Content addressable resources provide higher security than HTTPS/TLS (which
relies on centralized DNS and PKI infrastructures).  Resources loaded over
distributed protocols such as IPFS are adressed using a verifiable
cryptographic hash of the requested data.  It allows for trustless serving of
web sites.  HTTPS/TLS provides no such guarantees and introduces need for trust
in third parties (CA, DNS), opening a vector for MITM attacks.

Ideally, browser should verify cryptographic hash of loaded payload and, if
successful, mark its root resource as a secure context.  More realistic
approach is to mark resources opened using protocols created by [Programmable
Custom Protocol Handlers](/programmable-custom-protocol-handlers) as secure
contexts and leave cryptographic verification to the code behind protocol
handler.


## Status

- **W3C**  
  Suborigin spec: [W3C Editor's draft](https://w3c.github.io/webappsec-suborigins/), [Working Group Repo](https://github.com/w3c/webappsec-suborigins)  
  Secure Context spec: [W3C Secure Contexts](https://w3c.github.io/webappsec-secure-contexts/)
- **Brave**: ?
- **Beaker**: ?
- **Chromium**: Suborigin: [Bug #555117](https://bugs.chromium.org/p/chromium/issues/detail?id=555117), [Bug #580320](https://bugs.chromium.org/p/chromium/issues/detail?id=580320)
- **Edge**: ?
- **Firefox**: Suborigin: [Bug #1231225](https://bugzilla.mozilla.org/show_bug.cgi?id=1231225), [Bug #1391251](https://bugzilla.mozilla.org/show_bug.cgi?id=1391251)
- **Safari**: ?

