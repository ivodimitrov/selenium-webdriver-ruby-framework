# Set environment variables to Allure report from pipeline
class FileWrite
  def initialize(file_name, mode = 'w')
    @file = File.new file_name, mode
  end

  def write_allure_env(browser:, configuration:, scope:)
    @file.puts "Browser = #{browser}"
    @file.puts "Configuration = #{configuration}"
    @file.puts "Scope = #{scope}"
  end
end
