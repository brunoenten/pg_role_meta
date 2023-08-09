Feature: Functions set/get current_user
  Scenario: Set then Get a value
    Given the schema role_meta loaded
    And   a basic role bobzerole
    And   role bobzerole has usage of schema role_meta
    And   current user is bobzerole
    When calling function role_meta.set_to_current_user with arguments ('mykey', 'myvalue')
    And  calling function role_meta.get_from_current_user with arguments ('mykey')
    Then result should be 'myvalue'

  Scenario: Set a value then get it back from role
    Given the schema role_meta loaded
    And   a basic role bobzerole
    And   role bobzerole has usage of schema role_meta
    And   current user is bobzerole
    When calling function role_meta.set_to_current_user with arguments ('mykey', 'myvalue')
    And  calling function role_meta.get_from_role with arguments ('bobzerole', 'mykey')
    Then result should be 'myvalue'
