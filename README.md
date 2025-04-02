fzf
===

Sets up the Zsh shell integration for [fzf].

The following should be removed from your `~/.zshrc`, since this module will
already take care of it:

```zsh
source <(fzf --zsh)
```

Also configures [fzf] to use [bfs], [fd], [ripgrep] or [ugrep] for faster
fetching of files and directories names.

Sets ALT-C previews with [eza], [lsd] or ls. Also sets CTRL-T previews with [bat] if it's
installed. Press CTRL-/ to toggle the preview.

Requirements
------------

[fzf] >= 0.48.0 must be installed. And either [bfs], [fd], [ripgrep] or [ugrep]
must be installed already too.

[fzf]: https://github.com/junegunn/fzf
[bfs]: https://tavianator.com/projects/bfs.html
[fd]: https://github.com/sharkdp/fd
[ripgrep]: https://github.com/BurntSushi/ripgrep
[ugrep]: https://ugrep.com
[eza]: https://github.com/eza-community/eza
[lsd]: https://github.com/lsd-rs/lsd
[bat]: https://github.com/sharkdp/bat
