require 'rexml/document'

class XCode < Plugin

  @file = 'emacs.idekeybindings'
  @path = '~/Library/Developer/Xcode/UserData/KeyBindings'

  @incremental_search = false

  class << self
    attr_reader :file, :path
    attr_accessor :incremental_search
  end

  def start_incremental_search
    remap 'findNext:', '<Ctrl-s>'
    remap 'findPrevious:', '<Ctrl-r>'
    XCode.incremental_search = true
    send(@bindings['find:'])
  end

  def stop_incremental_search
    remap 'find:', '<Ctrl-s>', '<Ctrl-r>'
    XCode.incremental_search = false
  end

  
  def after
    @f = File.new(File.join(File.dirname(__FILE__), 'import.log'), 'w')
    @bindings = bindings_hash(find_keys(parse))

    only /Xcode/ do
      ## XCode Menu
      remap 'terminate:', '<Ctrl-x><Ctrl-c>'

      ## File Menu
      remap 'newTab:', '<Ctrl-x>c'
      remap 'openDocument:', '<Ctrl-x><Ctrl-f>'
      remap 'openQuickly:', '<Ctrl-Shift-t>'

      # XCode won't cooperate
      map '<Ctrl-x>k', '<Cmd-Ctrl-w>' # Close doc (other close remaps too)
      map '<Ctrl-x><Ctrl-s>', '<Cmd-;>' # Save
      map '<Ctrl-x>s', '<Cmd-Option-;>' # Save all

      ## Edit Menu
      remap 'undo:', '<Ctrl-/>'
      # TODO: cut, copy, paste
      remap 'selectAll:', '<Ctrl-x>h'

      # TODO: fix incremental search clusterfuck
      remap 'find:', '<Ctrl-s>'
      # ['s', 'r'].each do |key|
      #   map "<Ctrl-#{key}>" do
      #     start_incremental_search
      #   end
      # end

      # map '<Ctrl-Shift-s>' do
      #   stop_incremental_search
      # end

      map '<Ctrl-g>', '<Escape>'
      # map '<Ctrl-g>' do
      #   stop_incremental_search
      #   send('<Escape>')
      # end

      ## View Menu

      ## Navigate Menu

      ## Window Menu
      remap 'selectNextTab:', '<Ctrl-x>n'
      remap 'selectPreviousTab:', '<Ctrl-x>p'

      ## Text Menu
      # TODO: read from file
      map '<Ctrl-x>[', '<Option-Up>' # Go: File start
      map '<Ctrl-x>]', '<Option-Down>' # Go: File end
      map '<Cmd-b>', '<Option-Left>' # Backward word
      map '<Cmd-f>', '<Option-Right>' # Forward word
      map '<Cmd-t>', '<Cmd-Option-t>' # Transpose words

      map '<Cmd-w>' do
        send '<Option-Shift-y>' # Select to mark
        send '<Option-c>' # Copy
      end
      map '<Ctrl-x><Ctrl-k>', '<Option-Shift-u>' # Delete to mark
    end
    
  end

  private

  def parse
    REXML::Document.new File.new(File.expand_path "#{XCode.path}/#{XCode.file}")
  end

  def find_keys doc
    REXML::XPath.match doc, "//dict[key = 'Action']"
  end

  # From: <dict>
  #        <key>Action</key> <string>hide:</string>
  #        <key>...</key> <string>...</string>
  #      </dict>
  # To: { "Action" => "hide:" , ... }
  def xml_to_hash element
    Hash[element.elements.to_a.map(&:get_text).map(&:to_s).each_slice(2).to_a]
  end

  # ~ -> Option
  # ^ -> Ctrl
  # @ -> Cmd
  # $ -> Shift
  def convert_shortcut binding
    return nil if binding.nil?
    chars = binding.strip.split('').map do |c|
      c.downcase.sub(/\^/, 'Ctrl').sub(/~/, 'Option').sub(/@/, 'Cmd').sub(/\$/, 'Shift')
    end
    "<#{chars.join('-')}>"
  end
  
  def action_key_pair hash
    [hash['Action'], convert_shortcut(hash['Keyboard Shortcut'])]
  end

  def bindings_hash xml_keys
    Hash[xml_keys.map {|elem| xml_to_hash elem}.map { |h| action_key_pair(h).tap {|a| @f.write "Imported: #{a}\n"} }]
  end

  def remap(action, *keys)
    @f.write "Not found: '#{action}'" unless @bindings.key? action
    keys.each { |key| map key, @bindings[action] }
  end
end
