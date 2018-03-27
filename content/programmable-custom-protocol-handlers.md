---
title: "Programmable Custom Protocol Handlers"
date: 2018-03-26T17:23:44+01:00
---

An api that allows a WebExtension to register itself as **the handler for new protocols**, and can return responses to the browser.

- Beaker: Makes use of it from electron to serve dat:// urls.
- Brave: WIP https://github.com/brave/muon/pull/507
- Chrome: ?
- Edge: ?
- Firefox: https://bugzilla.mozilla.org/show_bug.cgi?id=1271553#c59
- Safari: ?

## Motivation

Users of a decentralized web want to get content from a network peers rather than a specific server.

Right now, only possible to register custom protocols handlers statically, from the `manifest.json`, where a uri is mapped to a url template, and a separate, centralised service must be maintained to handler the mapping. The custom protocol handler can only redirect the user to an (http) url, it cannot return content directly to the browser. The redirect is visible in the browsers url bar, and the original uri is no longer visible to the user.

## Usage Documentation

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

## Notes

- It's not [`navigator.registerProtocolHandler`][2]. That's the same as the the webextension version and restricted to redirecting to urls that match the current origin.
- Beaker Browser uses `registerStreamProtocol` to [handle `dat:` uris](
https://github.com/beakerbrowser/beaker/blob/984188245e69fe8035688292399c3f5b1aa51c25/app/background-process/protocols/dat.js#L53)


[1]: https://github.com/electron/electron/blob/master/docs/api/protocol.md#protocolregisterstreamprotocolscheme-handler-completion
[2]: https://developer.mozilla.org/en-US/docs/Web/API/Navigator/registerProtocolHandler
