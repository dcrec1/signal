# Rspec caching test plugin

This plugin helps you test your caching with rspec. It provides you with matchers to test if caching and expiring does what you want it to do. It is
currently only aiming at functional (controller) specifications.

This is basic but useful stuff, extracted from one of my projects. These are the matchers you get:

  * `lambda { ... }.should cache_page(url)`
  * ... `expire_page(url)`
  * ... `cache_action(action)`
  * ... `cache_fragment(name)`
  * ... `expire_action(action)`
  * ... `expire_fragment(name)`

Note that `cache_action` and `cache_fragment` are the same thing, only `cache_action` turns your `action` argument into the right `name` using `fragment_cache_key`. [See the Rails docs for more info](http://api.rubyonrails.org/classes/ActionController/Caching/Fragments.html#M000259 "Module: ActionController::Caching::Fragments").

## Installation

This is almost a drop-in solution. You only need to set up this plugin's
test hooks by calling its `setup` method, preferably in your
`spec_helper.rb` file like so:

    AGW::CacheTest.setup

## Example

Consider the following example specification:

    describe PostsController do
      describe "handling GET /posts" do
        it "should cache the page" do
          lambda { get :index }.should cache_page('/posts')
        end
   
        it "should cache the RSS feed" do
          lambda { 
            get :index, :format => 'rss' 
          }.should cache_page('/posts.rss')
        end
      end
    end

The `cache_page` matcher tests if your lambda actually triggers the caching.

    describe "handling GET /users/1" do
      it "should cache the action" do
        lambda { 
          get :show, :id => 1, :user_id => @user.id 
        }.should cache_action(:show)
      end
    end

The `cache_action` takes a symbol for the action of the current controller to test for, or an entire Hash to be used with `url_for`.

## Log

 1. **version 1.0 (I don't like beta)**
    
    The plugin works but remains without a test suite. A bit rough around the edges, maybe.

### To-do

  * Build full test suite.
  * Adapt for integration testing

## Credits

Copyright (c) 2008 Arjan van der Gaag, released under the MIT license