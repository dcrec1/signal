require File.join(File.dirname(__FILE__), "spec_helper.rb")

require 'paperclip'

create_table "people" do end

class Person < ActiveRecord::Base
  def names
    ["johny", "vitto"]
  end
end

describe Remarkable::InheritedResources do
  describe "have_a_name" do
    it "should validate that a model has a name" do
      have_a_name(:johny).matches?(Person.new).should be_true
    end
    
    it "should validate that a model doens't has a name" do
      have_a_name(:marcus).matches?(Person.new).should be_false
    end
  end
end