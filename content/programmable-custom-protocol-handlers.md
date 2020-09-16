---
title: "Protocol Handlers for DWeb URIs"
date: 2020-09-16T19:22+02:00
---

This is work in progress. Some vendors support DWeb natively, some enable limited support via browser extensions:

- Beaker: Makes use of Electron API to serve `dat://` and `hyper://` URIs
- Brave: Work in progress on native `ipfs://` and `ipns://` URI backed by either a public gateway or embedded go-ipfs support: [brave-browser/issues/10220](https://github.com/brave/brave-browser/issues/10220)
- Opera: *Opera for Android* supports native handler for `ipfs://` URI that redirects to the HTTP gateway of your choosing. Read more: [IPFS in Opera for Android](https://blog.ipfs.io/2020-03-30-ipfs-in-opera-for-android/).
- Chrome: *Chrome 86* [safelisted](https://blog.chromium.org/2020/09/chrome-86-improved-focus-highlighting.html) Distributed Web Schemes for redirect-based `registerProtocolHandler()`; [Protocol Labs](https://protocol.ai/) and [Igalia](https://igalia.com) work on improving protocol handler APIs in Chromium for both Web and WebExtension contexts.
- Edge: Supportive, looking into protocol handlers as [part of their PWA work](https://github.com/MicrosoftEdge/MSEdgeExplainers/blob/master/PwaUriHandler/explainer.md)
- Firefox: Supportive: [bug #1271553](https://bugzilla.mozilla.org/show_bug.cgi?id=1271553); In the past prototyped WebExtension API as a part of [libdweb](https://github.com/mozilla/libdweb): [Protocol handler API](https://github.com/mozilla/libdweb/issues/2)
- Safari: ?

## Motivation

Users of the distributed web want to get content from a network of peers rather than a specific server.

If the browser vendor does not support distributed web schemes natively,
there should be an api that allows a WebExtension to register itself as **the handler for new protocols**, and can return responses to the browser.

Right now, only possible to register custom protocols handlers statically, from the `manifest.json`, where a uri is mapped to a url template, and a separate, centralised service must be maintained to handler the mapping. The custom protocol handler can only redirect the user to an (http) url, it cannot return content directly to the browser. The redirect is visible in the browsers url bar, and the original uri is no longer visible to the user.

## Need: more powerful API for browser extensions

Using [`protocol.registerStreamProtocol`][1] in Electron as a starting point:

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

This is just a mockup based on prior art from Electron. The new API should leverage latest JS features, such as async iterators.

## Notes

- Chromium 86 [safelisted Distributed Web Schemes for `registerProtocolHandler()`][3], which is currently limited to setting up HTTP-based redirects.
- Browser extension API could be just a more powerful version of [`navigator.registerProtocolHandler`][2]
- Beaker Browser uses Electron-specific `registerStreamProtocol` API to [handle `dat:` uris](
https://github.com/beakerbrowser/beaker/blob/984188245e69fe8035688292399c3f5b1aa51c25/app/background-process/protocols/dat.js#L53)


[1]: https://github.com/electron/electron/blob/master/docs/api/protocol.md#protocolregisterstreamprotocolscheme-handler-completion
[2]: https://developer.mozilla.org/en-US/docs/Web/API/Navigator/registerProtocolHandler
[3]: https://blog.chromium.org/2020/09/chrome-86-improved-focus-highlighting.html
