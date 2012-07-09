start_at_login(true)
map "<Ctrl-Shift-R>" { reload }

def unbind(key, *modifiers)
  return if modifiers.empty? or key.size != 1
  seq = "<#{modifiers.join('-')}-#{key}>"
  map seq, nil
end

## iTerm
only /iTerm/ do
  # Don't quit except via command line
  ['w', 'q', 'r', 't'].each do |key|
    unbind key, 'Cmd'
  end

  # Copy/Paste
  ['c', 'v'].each do |key|
    map "<Ctrl-Shift-#{key}>", "<Cmd-#{key}>"
  end
end
