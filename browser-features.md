# Are We Distributed Yet?

**Extension APIs**

## Programmable Custom Protocol handlers in WebExtentions

An api that allows a WebExtension to register itself as **the handler for new protocols**, and can return responses to the browser.

Firefox: https://bugzilla.mozilla.org/show_bug.cgi?id=1271553#c59
Chrome: ?
Edge: ?
Safari: ?

### Motivation

Users of a decentralized web want to get content from a network peers rather than a specific server.

Right now, only possible to register custom protocols handlers statically, from the manifest.json, where a uri is mapped to a url template, and a separate, centralised webapp must be maintained to handler the mapping. The custom protocol handler can only redirect the user to an (http) url, it cannot return content directly to the browser. The redirect is visible in the browsers url bar, and the original uri is no longer visible to the user.

### Usage Documentation

Using [`protocol.registerStreamProtocol`][1] in electron as a starting point

```js
browser.protocol.registerStreamProtocol('ipfs', (request, callback) => {
  const {cid, contentType} = extractInfo(request)  // an exercise for the reader
  const stream = ipfs.files.catReadableStream(cid)
  callback({
    statusCode: 200,
    headers: {
      'Content-Type': contentType
    }
    data: stream
  })
}, (error) => {
  if (error) console.error('Failed to register protocol')
})
```

This example shows how you would add a handler for the `ipfs` protocol and have it return a file retrieved via the IPFS network as a stream to the browser.

### Notes

- Brave via Muon implements [`protocol.registerStringProtocol`] which is a good start.
- It's not [`navigator.registerProtocolHandler`][2]. That's the same as the the webextension version and restricted to redirecting to urls that match the current origin.
- here's Beaker Browser using it to [handle `dat:` uris](
https://github.com/beakerbrowser/beaker/blob/984188245e69fe8035688292399c3f5b1aa51c25/app/background-process/protocols/dat.js#L53)

## Control how content origin is determined
- Sub origin https://github.com/ipfs/in-web-browsers/issues/66
- Control How Origin Is Calculated for _originless_ content addressed uris
- See: https://bugzilla.mozilla.org/show_bug.cgi?id=1271553#c47

## DNS query api

- Support for DNS TXT lookups for DNSLINK
- Firefox: https://bugzilla.mozilla.org/show_bug.cgi?id=1343849#c3
- Beaker is using .Well-known file over TLS
https://github.com/beakerbrowser/beaker/wiki/Authenticated-Dat-URLs-and-HTTPS-to-Dat-Discovery

## WebRTC and PeerConnections in WebExtensions

See: https://github.com/w3c/webrtc-pc/pull/317

## Streaming Crypto apis

See: https://github.com/w3c/webcrypto/issues/73

## Crypto apis in non secure contexts

See: https://github.com/libp2p/js-libp2p-crypto/issues/105


[1]: https://github.com/electron/electron/blob/master/docs/api/protocol.md#protocolregisterstreamprotocolscheme-handler-completion
[2]: https://developer.mozilla.org/en-US/docs/Web/API/Navigator/registerProtocolHandler
