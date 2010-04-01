Feature: Manage projects

  Scenario: Register new project
    Given I am on the new projects page
    When I fill in "project_name" with "Geni"
    And I fill in "project_url" with "git://fake"
    And I fill in "project_email" with "fake@too.com"
    And I press "Create Project"
    Then a new project should be created
    And I should see /Geni/

  Scenario: Update a project
    Given I have a project
    And I am on the edit project page
    When I fill in "project_name" with "Bluepump"
    When I fill in "project_url" with "gitFake"
    And I press "Save Project"
    Then I should see /Bluepump/
    And I should see /gitFake/

  Scenario: Build project
    Given I have a project
    And I am on the project page
    When I follow "build"
    Then a new build should be created
    And I should see the author of the build
    And I should see the name of the project

  Scenario: Deploy Project
    Given I have a project
    And I am on the project page
    When I follow "deploy"
    Then a new deploy should be created
    And I should see the output of the deploy
    And I should see the name of the project
    
  Scenario: Get projects status in XML format
    When I request '/projects/status.xml'
    Then I should get a XML document

  Scenario: RSS
    Given I have a project
    When I request '/'
    Then I should receive a link for the feed
    When I request 'http://localhost:3000/projects.rss' 
    Then I should see the name of the project
