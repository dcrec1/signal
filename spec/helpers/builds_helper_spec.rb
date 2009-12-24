require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildsHelper do
  include BuildsHelper

  it "should format output replacing ANSI color codes with spans" do
    input = "\e[32m.\e[0m\e[32m.\e[0m\e[32m.\e[0m\e[32m.\e[0m"
    output = '<span class="color32">.</span><span class="color32">.</span><span class="color32">.</span><span class="color32">.</span>'
    format_output(input).should eql(output)
  end
end
