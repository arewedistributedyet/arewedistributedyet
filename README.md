# Are we distributed yet?

_Let's unlock the peer-to-peer web_ ⚡🌐🔑

- Built with [hugo]
- Styled with [tachyons] & [ipfs-css]

## Usage

- `make dev` - Dev mode. See the site (with live reloading) at http://localhost:1313
- `make` - Build the production ready site to `./public`
- `make deploy` - Add `./public` to [IPFS]
- `make help` - For more info

## Adding content

The site is built from `data/topics.json`. Add your feature or browser specific details on an existing feature there and submit a PR.

Data for a topic looks like this

```js
  {
    "name": "P2P enthusiasm",
    "description": "Are they excited about the distributed web and are they publicly committed to making it happen?",
    "beaker": {
      "level": 2,
      "details": "Yes! _a peer-to-peer browser with tools to create and host websites. Don't just browse the Web, build it._ https://beakerbrowser.com"
    },
    "brave": {
      "level": 1,
      "details": "Supportive. https://github.com/brave/browser-laptop/issues/9556"
    },
    "chrome": {
      "level": 0
    },
    "edge": {
      "level": 0
    },
    "firefox": {
      "level": 1,
      "details": "Supportive: <a href='https://bugzilla.mozilla.org/show_bug.cgi?id=1435798'>https://bugzilla.mozilla.org/show_bug.cgi?id=1435798</a>"
    },
    "safari": {
      "level": 0
    }
  }
```

Where

- `level: 0` means we don't know yet. This is the **default**.
- `level: 1` means the browser is positive, but there are caveats or unknowns.
- `level: 2` means the idea is shipped or they are publicly committed to shipping it.

## Inspiration

- https://jakearchibald.github.io/isserviceworkerready/
- http://www.areweplayingyet.org/
- https://github.com/datprotocol/DEPs

## License

Documents are [CC-BY-SA 3.0] license © 2018 Protocol Labs Inc.
Code is [MIT](./LICENSE) © 2018 Protocol Labs Inc.

[IPFS]: https://ipfs.io
[hugo]: https://gohugo.io
[tachyons]: http://tachyons.io
[ipfs-css]: https://github.com/ipfs-shipyard/ipfs-css
[CC-BY-SA 3.0]: https://ipfs.io/ipfs/QmVreNvKsQmQZ83T86cWSjPu2vR3yZHGPm5jnxFuunEB9u
