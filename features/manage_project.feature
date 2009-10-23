Feature: Manage projects

  Scenario: Register new project
    Given I am on the new projects page
    When I fill in "project_name" with "Geni"
    And I fill in "project_url" with "git://fake"
    And I fill in "project_email" with "fake@too.com"
    And I press "Create Project"
    Then a new project should be created
    And I should see /Geni/
