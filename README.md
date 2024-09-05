# crystal-jitter

Repositions the mouse while the mouse is inert to avoid screen 
locking on Windows.

At random intervals between 1 and 30 seconds, the mouse will be 
repositioned by 1 to 10 pixels randomly up/down and left/right from 
its current position and then repositioned back to its original 
position immediately.

The mouse will only be repositioned if its position has not changed 
since the last time we checked its position. This vastly reduces the 
effect of the mouse being repositioned during active use, such that 
running the program is effectively invisible to the user.

## Installation

To build from source:

- Install scoop: refer to https://scoop.sh/
- Install crystal: refer to https://github.com/neatorobito/scoop-crystal
- Clone repo: `git clone https://github.com/lachlan/crystal-jitter`
- Install dependencies: `shards install`
- Build: `shards build --static --release`

Or download pre-built binary `jitter.exe` from [releases](https://github.com/lachlan/crystal-jitter/releases).
Put the pre-built binary in whatever directory you like, and rename it 
to whatever filename.exe you like. Then run it manually or schedule it
to run at startup / login using the Windows task scheduler.

## Usage

Run `jitter.exe` and it will run forever; use `CTRL-C` to stop it.

```
C:\Some\Directory\jitter.exe
2024-07-07T01:25:53.125260Z   INFO - JITTER: Started
2024-07-07T01:25:53.128625Z   INFO - JITTER: Status:     position = (x = 508, y = 645), screen = 1470x919
2024-07-07T01:25:53.128627Z   INFO - JITTER: Sleeping:   00:00:26.147264439
2024-07-07T01:26:19.289584Z   INFO - JITTER: Status:     position = (x = 508, y = 645), screen = 1470x919
2024-07-07T01:26:19.289851Z   INFO - JITTER: Reposition: position = (x = 508, y = 645) -> (x = 509, y = 646) -> (x = 508, y = 645)
2024-07-07T01:26:19.289853Z   INFO - JITTER: Sleeping:   00:00:04.507010501
2024-07-07T01:26:23.797378Z   INFO - JITTER: Status:     position = (x = 508, y = 645), screen = 1470x919
2024-07-07T01:26:23.797706Z   INFO - JITTER: Reposition: position = (x = 508, y = 645) -> (x = 509, y = 644) -> (x = 508, y = 645)
2024-07-07T01:26:23.797710Z   INFO - JITTER: Sleeping:   00:00:14.587796993
2024-07-07T01:26:38.398313Z   INFO - JITTER: Status:     position = (x = 887, y = 728), screen = 1470x919
2024-07-07T01:26:38.398316Z   INFO - JITTER: Sleeping:   00:00:25.906205343
^C
```

## Contributing

1. Fork it (<https://github.com/lachlan/crystal-jitter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lachlan Dowding](https://github.com/lachlan) - creator and maintainer
