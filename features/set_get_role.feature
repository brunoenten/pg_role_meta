Feature: Functions set/get Role
  Scenario: Set then Get a value
    Given a basic role bobzerole
    And   the schema role_meta loaded
    When calling function role_meta.set_to_role with arguments ('bobzerole', 'mykey', 'myvalue')
    And  calling function role_meta.get_from_role with arguments ('bobzerole', 'mykey')
    Then result should be 'myvalue'
