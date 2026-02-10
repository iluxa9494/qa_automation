Feature: Database usage MongoDB

  Background:
    * Connect to MongoDB "world" database

  Scenario: Create collection in mongoDB
    * Create "city" collection in mongoDB

  Scenario: Create data in mongoDB collection (Create)
    * Create document in the collection with data:
      | ID          | 1       |
      | Name        | Russia  |
      | CountryCode | RUS     |
      | District    | Rostov  |
      | Population  | 2000000 |

  Scenario: Read data from mongoDB collection (Read)
    * Read data from document and compare it has:
      | ID          | 1       |
      | Name        | Russia  |
      | CountryCode | RUS     |
      | District    | Rostov  |
      | Population  | 2000000 |
#
  Scenario: Update data in mongoDB collection (Update)
    * Update District on Vladivostok value from document and compare it has:
      | ID          | 1           |
      | Name        | Russia      |
      | CountryCode | RUS         |
      | District    | Vladivostok |
      | Population  | 1000000     |

  Scenario: Delete data in mongoDB (Delete)
    * Delete document in the MongoDB data:
      | ID | 1 |

  Scenario: Delete collection in mongoDB
    * Delete collection in mongoDB