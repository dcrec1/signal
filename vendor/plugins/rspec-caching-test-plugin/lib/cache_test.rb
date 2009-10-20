# Copyright (c) 2008 Arjan van der Gaag, AG Webdesign
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
module AGW #:nodoc:

  # = Rspec caching test plugin
  # 
  # This plugin helps you test your caching with rspec. It provides you with
  # matchers to test if caching and expiring does what you want it to do.
  # 
  # This is basic but useful stuff, extracted from one of my projects. Here's
  # all the matches you'll get:
  # 
  # * <tt>cache_page(url)</tt>
  # * <tt>expire_page(url)</tt>
  # * <tt>cache_action(action)</tt>
  # * <tt>cache_fragment(name)</tt>
  # * <tt>expire_action(action)</tt>
  # * <tt>expire_fragment(name)</tt>
  # 
  # Note that +cache_action+ and +cache_fragment+ are the same thing, only
  # +cache_action+ turns your +action+ argument into the right +name+ using
  # +fragment_cache_key+.
  #
  # == Installation
  #
  # This is almost a drop-in solution. You only need to set up this plugin's
  # test hooks by calling its +setup+ method, preferably in your
  # <tt>spec_helper.rb</tt> file like so:
  #
  #   AGW::CacheTest.setup
  #
  # == Example
  # 
  # Consider the following example specification:
  # 
  #   describe PostsController do
  #     describe "handling GET /posts" do
  #       it "should cache the page" do
  #         lambda { get :index }.should cache_page('/posts')
  #       end
  #   
  #       it "should cache the RSS feed" do
  #         lambda { 
  #           get :index, :format => 'rss' 
  #         }.should cache_page('/posts.rss')
  #       end
  #     end
  #   end
  # 
  # The +cache_page+ matcher tests if your lambda actually triggers the 
  # caching.
  # 
  #   describe "handling GET /users/1" do
  #     it "should cache the action" do
  #       lambda { 
  #         get :show, :id => 1, :user_id => @user.id 
  #       }.should cache_action(:show)
  #     end
  #   end
  # 
  # The +cache_action+ takes a symbol for the action of the current controller
  # to test for, or an entire Hash to be used with +url_for+.
  #
  # Author::    Arjan van der Gaag (info@agwebdesign.nl)
  # Copyright:: copyright (c) 2008 AG Webdesign
  # License::   distributed under the same terms as Ruby.
  module CacheTest
    
    # Call this method to set up this caching mechanism in your code.
    # Ideally this would go into your +spec_helper.rb+.
    #
    # This method enables caching and hooks into the fragment and page
    # caching systems to let all caching flow through this plugin. It also
    # enables the rspec matchers.
    #
    # This method must be called to activate the plugin:
    #
    #   AGW::CacheTest.setup
    # 
    #--
    # TODO: somehow drop this in init.rb
    def self.setup
      # Turn on caching
      ActionController::Base.perform_caching = true

      # Hook into the fragment and page caching mechanisms
      ActionController::Base.cache_store = AGW::CacheTest::TestStore.new
      ActionController::Base.class_eval do
        include AGW::CacheTest::PageCaching
      end
      
      # Make our matchers available to rspec via Test::Unit
      Test::Unit::TestCase.class_eval do
        include Matchers
      end
    end
    
    # This class is the cache store used during testing. All fragment caching
    # requests come to here. It tells us what was cached and what was
    # expired by the application.
    #
    # == Usage
    #
    # The application uses this class in its caching. In tests we can
    # ask the class about this as follows:
    #
    #   @test_store = TestStore.new
    #   ...trigger caching...
    #   @test_store.cached?('my_page') # => true
    #   @test_store.expired?('my_page') # => false
    #   ...trigger expiration...
    #   @test_store.expired?('my_page') # => true
    # 
    # == Perform the actual caching
    #
    # This test cache store can actually cache content, but by default
    # does not. If it caches and returns cached content this might affect
    # your tests, forcing you to reset the cache for every test so as to
    # get the desired behaviour.
    #
    # The default behaviour is set on creation of the TestStore by
    # passing in a simple flag. You can, however, change this at run time
    # like so:
    #
    #   @a = TestStore.new       # => caching is off
    #   @a.read_cache = true     # => caching is on
    #   
    #   @b = TestStore.new(true) # => caching is on
    #   @b.read_cache = false    # => caching is off
    #
    # When needed the cache can be cleared manually like so:
    #
    #   ActionController::Base.cache_store.reset
    # 
    class TestStore < ActiveSupport::Cache::Store

      # Record of what the app tells us to cache
      attr_reader :cached
      
      # Record of what the app tells us to expire
      attr_reader :expired
      
      # Record of what the app tells us to expire via patterns
      attr_reader :expiration_patterns
      
      # Cached data that could be returned
      attr_reader :data
      
      # Setting to enable the returning of cached data.
      attr_accessor :read_cache

      def initialize(do_read_cache = false) #:nodoc:
        @data                = {}
        @cached              = []
        @expired             = []
        @expiration_patterns = []
        @read_cache          = do_read_cache
      end
      
      # Reset the cache store, effectively emptying the cache
      def reset
        @data.clear
        @cached.clear
        @expired.clear
        @expiration_patterns.clear
      end

      def read(name, options = nil) #:nodoc:
        super
        read_cache ? @data[name] : nil
      end

      def write(name, value, options = nil) #:nodoc:
        super
        
        # Actually store the data if desired
        @data[name] = value if read_cache
        
        # Record this caching
        @cached << name
      end

      def delete(name, options = nil) #:nodoc:
        super
        @expired << name
      end

      def delete_matched(matcher, options = nil) #:nodoc:
        super
        @expiration_patterns << matcher
      end

      # See if a given name was written to the cache
      def cached?(name)
        @cached.include?(name)
      end
      
      # See if a given name was expired from the cache, eiter directly or
      # using an expiration pattern.
      def expired?(name)
        @expired.include?(name) || @expiration_patterns.detect { |matcher| name =~ matcher }
      end
    end

    # This modulse can override the default page caching framework
    # and intercept all caching and expiration requests to keep
    # track of what the apps caches and expires.
    #
    # Methods are added to <tt>ActionController::Base</tt> to test for caching and 
    # expiring (See AGW::CacheTest::PageCaching::InstanceMethods)
    module PageCaching
      module ClassMethods #:nodoc:
        def cache_page(content, path)
          test_page_cached << path
        end

        def expire_page(path)
          test_page_expired << path
        end
      
        def cached?(path)
          test_page_cached.include?(path)
        end

        def expired?(path)
          test_page_expired.include?(path)
        end
      
        def reset_page_cache!
          test_page_cached.clear
          test_page_expired.clear
        end
      end
      
      module InstanceMethods
        # See if the page caching mechanism has cached a given url. This takes
        # the same options as +url_for+.
        def cached?(options = {})
          self.class.cached?(test_cache_url(options))
        end

        # See if the page caching mechanism has expired a given url. This 
        # takes the same options as +url_for+.
        def expired?(options = {})
          self.class.expired?(test_cache_url(options))
        end
        
        private
        
          def test_cache_url(options) #:nodoc:
            url_for(options.merge({ :only_path => true, :skip_relative_url_root => true }))
          end
      end
      
      def self.included(receiver) #:nodoc:
        receiver.class_eval do
          @@test_page_cached  = [] # keep track of what gets cached
          @@test_page_expired = [] # keeg track of what gets expired
          cattr_accessor :test_page_cached
          cattr_accessor :test_page_expired
        end
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end

    # The rspec matchers give do the actual testing of your logic. These
    # matchers work on a block of code and take a URL, action or name as
    # argument. They all work in more or less the same way.
    #
    # Note that although these matchers are written for rspec, the
    # underlying concepts can easily be applied to <tt>Test::Unit</tt> or
    # something else.
    module Matchers
      class TestCacheCaches #:nodoc:
        def initialize(name, controller = nil)
          @name       = name
          @controller = controller
          ActionController::Base.cache_store.reset
        end

        # Call the block of code passed to this matcher and see if
        # our action has been written to the cache.
        #
        # We determine the +fragment_cache_key+ here, taking the effort to
        # pass in the controller to this class, because this method only
        # works in the context of a request. Calling the block gives us that
        # request.
        def matches?(block)
          block.call
          @key = @name.is_a?(String) ? @name : @controller.fragment_cache_key(@name)
          return ActionController::Base.cache_store.cached?(@key)
        end

        def failure_message
          reason = if ActionController::Base.cache_store.cached.any?
            "the cache only has #{ActionController::Base.cache_store.cached.to_yaml}."
          else
            "the cache is empty."
          end
          "Expected block to cache action #{@name.inspect} (#{@key}), but #{reason}"
        end

        def negative_failure_message
          "Expected block not to cache action #{@name.inspect} (#{@key})"
        end
      end

      # See if an acion gets cached
      #
      # Usage:
      #
      #   lambda { get :index }.should cache_action(:index)
      # 
      # You can pass in the name of an action which will then get
      # interpreted in the context of the current controller. Alternatively,
      # you can pass in a whole +Hash+ for +url_for+ defining all your
      # paramaters.
      def cache_action(action)
        action = { :action => action } unless action.is_a?(Hash)
        TestCacheCaches.new(action, controller)
      end
      
      # See if a fragment gets cached.
      #
      # The name you pass in can be any name you have given your fragment.
      # This would typically be a +String+.
      #
      # Usage:
      #
      #   lambda { get :index }.should cache('my_caching')
      # 
      def cache(name)
        TestCacheCaches.new(name)
      end
      alias_method :cache_fragment, :cache
      
      class TestCacheExpires #:nodoc:
        def initialize(name, controller)
          @name       = name
          @controller = controller
          ActionController::Base.cache_store.reset
        end

        # Call the block of code passed to this matcher and see if
        # our action has been removed from the cache.
        #
        # We determine the +fragment_cache_key+ here, taking the effort to
        # pass in the controller to this class, because this method only
        # works in the context of a request. Calling the block gives us that
        # request.
        def matches?(block)
          block.call
          @key = @name.is_a?(String) ? @name : @controller.fragment_cache_key(@name)
          return ActionController::Base.cache_store.expired?(@key)
        end

        def failure_message
          reason = if ActionController::Base.cache_store.expired.any?
            "the cache has only expired #{ActionController::Base.cache_store.expired.to_yaml}."
          else
            "nothing was expired."
          end
          "Expected block to expire action #{@name.inspect} (#{@key}), but #{reason}"
        end

        def negative_failure_message
          "Expected block not to expire #{@name.inspect} (#{@key})"
        end
      end

      # See if an action is expired
      #
      # Usage:
      # 
      #   lambda { get :index }.should expire_action(:index)
      # 
      # You can pass in the name of an action which will then get
      # interpreted in the context of the current controller. Alternatively,
      # you can pass in a whole +Hash+ for +url_for+ defining all your
      # paramaters.
      #
      # This is a shortcut method to +expire+.
      def expire_action(action)
        action = { :action => action } unless action.is_a?(Hash)
        expire(action)
      end

      # See if a fragment is expired
      #
      # The name you pass in can be any name you have given your fragment.
      # This would typically be a +String+.
      #
      # Usage:
      # 
      #   lambda { get :index }.should expire('my_cached_something')
      # 
      def expire(name)
        TestCacheExpires.new(name, controller)
      end
      alias_method :expire_fragment, :expire
      
      class CachePage #:nodoc:
        def initialize(url)
          @url = url
          ActionController::Base.reset_page_cache!
        end
        
        # See if +ActionController::Base+ was told to cache our page.
        def matches?(block)
          block.call 
          return ActionController::Base.cached?(@url)
        end

        def failure_message
          "Expected block to cache the page #{@url.inspect}"
        end

        def negative_failure_message
          "Expected block not to cache the page #{@url.inspect}"
        end
      end

      # See if a page URL (or relative path) gets cached
      #
      # Usage:
      #
      #   lambda { get :index }.should cache_page('/posts')
      # 
      def cache_page(url)
        CachePage.new(url)
      end

      class ExpirePage #:nodoc:
        def initialize(url)
          @url = url
          ActionController::Base.reset_page_cache!
        end

        def matches?(block)
          block.call 
          return ActionController::Base.expired?(@url)
        end

        def failure_message
          if ActionController::Base.test_page_expired.any?
            "Expected block to expire the page #{@url.inspect} but it only expired #{ActionController::Base.test_page_expired.to_yaml}"
          else
            "Expected block to expire the page #{@url.inspect} but it expired nothing"
          end
        end

        def negative_failure_message
          "Expected block not to expire the page #{@url.inspect}"
        end
      end

      # See if a page URL (or relative path) gets expired
      #
      # Usage:
      #
      #   lambda { get :index }.should expire_page('/posts')
      # 
      def expire_page(url)
        ExpirePage.new(url)
      end
    end
  end
end