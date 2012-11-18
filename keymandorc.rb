start_at_login(true)

# use growl as the default notifier instead of alert dialogs
MessageBoard.change_notifier_to(GrowlNotifier)

## Global bindings
map '<Ctrl-Shift-r>' do reload end
map '<Cmd-Shift-l>' do lock_screen end

## Helpers

def unbind(key, *modifiers)
  return if modifiers.empty? or key.size != 1
  seq = "<#{modifiers.join('-')}-#{key}>"
  map seq, nil
end

def controlify(keys)
  keys = [keys] if keys.class == String
  keys.each do |key|
    map "<Ctrl-#{key}>", "<Cmd-#{key}>"
  end
end

## iTerm
only /iTerm/ do
  # Don't quit except via command line
  ['w', 'q', 'r', 't'].each do |key|
    unbind key, 'Cmd'
  end

  # Emacs style forward/backward word
  map '<Cmd-b>', '<Option-b>'
  map '<Cmd-f>', '<Option-f>'

  # Copy/Paste
  ['c', 'v'].each do |key|
    map "<Ctrl-Shift-#{key}>", "<Cmd-#{key}>"
  end
end

## Chrome
only /Chrome/ do
  # remap tab selection
  controlify (1..9).to_a

  # remap some functions to Ctrl-letter
  controlify ['a', 'l', 'n', 't', 'w', 'c', 'v', 'x', 'r']

  # Emacs style cancel
  map '<Ctrl-g>', '<Escape>'

  # Emacs style forward/backward word
  map '<Cmd-b>', '<Option-Left>'
  map '<Cmd-f>', '<Option-Right>'
end

## Remap bindings in the form Cmd-letter to Ctrl-letter for apps that
## don't use emacs-style bindings
except /iTerm/, /Emacs/, /Quicksilver/, /Xcode/, /Chrome/, /Eclipse/ do
  controlify ('a'..'z').to_a
end
