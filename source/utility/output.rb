module Output

  def self.help
    output 'game-help',
           'commands'
  end

  def self.welcome
    output 'welcome',
           'commands',
           'delimiter'
  end

  def self.output(*resources)
    resources.each do |resource|
      process "resources/#{resource}"
    end
  end

  def self.process(path)
    puts File.read path if File.exist? path
  end

  private_class_method :output
  private_class_method :process

end
