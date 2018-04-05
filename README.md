# Are we distributed yet?

_Let's unlock the peer-to-peer web_ ⚡🌐🔑

> ...a comprehensive, prioritized list that we can point browser people too. Ideally with a brief description which features each of the items unlocks. There are things which are absolute deal-breakers (e.g. proper protocol handlers), and things which are important but not essential. The list should convey this importance and priorities.
> @lgierth

## Usage

- `make dev` - Dev mode. See the site with live reloading at http://localhost:1313
- `make` - Build the static site to `./public`
- `make deploy` - Add `./public` to [IPFS]
- `make help` - For more info

Built with [hugo], styled with [tachyons] & [ipfs-css]

## Contributing

This site documents the browser features and fixes needed to improve the user-experience of the distributed web. **Come join us** in the <a href="https://www.irccloud.com/invite?channel=%23ipfs-in-web-browsers&amp;hostname=irc.freenode.net&amp;port=6697&amp;ssl=1"> #ipfs-in-web-browsers channel on irc.freenode.net</a> and feel free to ask questions!

**To suggest a new topic** create a [new issue](https://github.com/ipfs-shipyard/arewedistributedyet/issue) for it where we can figure out the details. Each topic should define what is needed, and what feature it unlocks. There is an issue template to guide the process. We'll discuss the issue and look for consensus on the ideal specification, and encourage p2p protocol developers and browser developers to help refine each issue.

**To submit a proposal** create a new markdown document in the `./content` directory by running

```sh
hugo new <your-hyphenated-lowercase-topic-title-here.md>
```

That will create the proposal structure for you, with the filename you provided in the content dir. Once your happy with it, submit it as PR.

**To update the homepage** update `data/topics.json` with the new feature or browser specific details and submit a PR.

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

Once there is a published proposal document for a topic, you can add a link to it by adding a `doc` property with the proposal filename (without it's file extension) as the value, in the relevant topic object in `data/topics.json`.

## Inspiration

- http://www.areweplayingyet.org
- https://jakearchibald.github.io/isserviceworkerready
- https://github.com/datprotocol/DEPs

## License

Documents are [CC-BY-SA 3.0] license © 2018 Protocol Labs Inc.
Code is [MIT](./LICENSE) © 2018 Protocol Labs Inc.

[IPFS]: https://ipfs.io
[hugo]: https://gohugo.io
[tachyons]: http://tachyons.io
[ipfs-css]: https://github.com/ipfs-shipyard/ipfs-css
[CC-BY-SA 3.0]: https://ipfs.io/ipfs/QmVreNvKsQmQZ83T86cWSjPu2vR3yZHGPm5jnxFuunEB9u
