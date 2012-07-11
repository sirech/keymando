## Emacs-style keybindings for XCode 4

Trying to customize _XCode_ to do what you want is a great way to lose
the will to live. This is an attempt to circumvent some of the
limitations, to emulate some basic behaviors from _emacs_, the only
true editor.

### Installation

Copy the `emacs.idekeybindings` to
`~/Library/Developer/Xcode/UserData/KeyBindings`, select it in _XCode_
in _Preferences > Key Bindings > Command Sets_. Keep in mind that a
symlink won't work, as the file is overriden each time you change
something.

### Limitations that make everything more difficult

 * You can't use a sequence of keys (like C-x C-f).
 * You can't execute multiple commands with a key (anymore).
 * Some commands can only be mapped to a Cmd-something binding.
 
### How it works

There are some emacs-style bindings that are put in the _Control_
key. These are mostly left alone.

Most of the bindings that use _Command_ are moved to _Option_, and
remapped from this plugin itself. Some are directly remapped to the
emacs equivalent.

Finally, some things are not available in XCode and have to be
emulated by sending multiple keys.

All this means that the config is split between the bindings and the
plugin configuration, where some more complex bindings are put.

#### Parsing the keybindings

To avoid some duplication and provide some flexibility, the file used
to store the keybindings is parsed, and the name of the command is
used for the remap, instead of the current binding. This helps a bit
in case the binding is changed in XCode.  The drawback is that this
only works for commands that are reassigned in XCode, as the default
keys don't appear in the file.

Another problem is that some commands use a completely different
syntax for the bindings. These are currently not supported.

### TODO's

 * Incremental search kind of sucks. A proper emulation requires
   maintaining some sort of state, which doesn't seem so simple.
 * Split window commands.
