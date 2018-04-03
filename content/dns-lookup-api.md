---
title: "DNS lookup API"
date: 2018-03-29T14:49:22+02:00
---

An API that allows a WebExtension to perform DNS lookups for arbitrary record
types in a highly efficient manner.

## Motivation

Use DNS lookup to create a bridge between centralized and decentralized technologies.

There are two DNS resource record types that are relevant to this objective:

- `SRV` records provide means for specifying the location of services ([RFC 2782][2]).
- `TXT` records provide the ability to associate arbitrary string metadata with a host ([RFC 1464](https://tools.ietf.org/html/rfc1464)).

`TXT` records are much more versatile. There are historical examples of
[publishing PGP pubkeys][3], [domain ownership verification][4],
['serverless' redirect services][5] and more.

IPFS uses `TXT` records for publishing [dnslink][6] as a means of exposing content
from an IPFS Path under `/ipns/${fqdn}/` namespace. Validation of `/ipns/` paths
includes a DNS lookup to verify if `/ipns/${fqdn}` is backed by the presence of
a dnslink `TXT` record. 

Without a dedicated API for DNS lookups browser extensions are forced to use
third-party [DNS-over-HTTPS][7] services.
This workaround comes at a price:

- Dependency on hardcoded third party lookup service introduces a single
  point of failure.  It also makes MITM attacks easier and increases
  probability of leaking private information.

- Sending an HTTP GET for each query is much slower than native DNS client already
 present in web browser.
 The overhead is particularly undesirable during time-critical paths such as
 [blocking `onBeforeRequest` handler][8] (degrades browsing performance, kills battery).



## Usage Documentation

The recently added [`browser.dns.resolve`][1] API from Firefox 60 is a good starting point.
There should be an additional parameter that enables extension to lookup for
record types different from the default `A`.

Example below shows how a lookup for `TXT` record could work in mentioned API:

```js
function resolved(record) {
  console.log(record.addresses);
}

let resolving = browser.dns.resolve("ipfs.io", ["rr_type_txt"]);
resolving.then(resolved);

// > e.g. Array [ "dnslink=/ipfs/QmYNQJoKGNHTpPxCBPh9KkDpaExgd2duMa3aF6ytMpHdao" ]
```

## Notes

- `browser.dns.resolve` in Firefox 60 is limited to `A`/`AAAA` records.
  It is impossible to perform lookups for other record types such as `SRV` ([Bug 14328](https://bugzilla.mozilla.org/show_bug.cgi?id=14328)) or `TXT` ([Bug 1449171](https://bugzilla.mozilla.org/show_bug.cgi?id=1449171)).


[1]: https://developer.mozilla.org/en-US/Add-ons/WebExtensions/API/dns/resolve 
[2]: https://www.ietf.org/rfc/rfc2782.txt
[3]: http://www.gushi.org/make-dns-cert/howto.html
[4]: https://support.google.com/a/answer/183895?hl=en
[5]: http://redirect.name/
[6]: https://ipfs.io/docs/examples/example-viewer/example#../websites/README.md
[7]: https://developers.google.com/speed/public-dns/docs/dns-over-https
[8]: https://developer.mozilla.org/en-US/Add-ons/WebExtensions/API/webRequest/onBeforeRequest
