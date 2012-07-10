require 'rexml/document'

class XCode # < Plugin

  @file = 'emacs.idekeybindings'
  @path = '~/Library/Developer/Xcode/UserData/KeyBindings'

  class << self ; attr_accessor :file, :path; end

  def after
    bindings_hash(find_keys(parse))
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
  def convert_shortcut binding
    return nil if binding.nil?
    chars = binding.strip.split('').map do |c|
      c.sub(/\^/, 'Ctrl').sub(/~/, 'Option').sub(/@/, 'Cmd')
    end
    "<#{chars.join('-')}>"
  end
  
  def action_key_pair hash
    [hash['Action'], convert_shortcut(hash['Keyboard Shortcut'])]
  end

  def bindings_hash xml_keys
    Hash[xml_keys.map {|elem| xml_to_hash elem}.map { |h| action_key_pair h}]
  end
end
