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
