Feature: Database usage MySQL

  Background:
    * Connect to MySQL city database

  Scenario: Create data in db (Create)
    * Create position in the db with data:
      | ID          | 4080    |
      | Name        | Russia  |
      | CountryCode | RUS     |
      | District    | Rostov  |
      | Population  | 2000000 |
    * Close db connection

  Scenario: Get data from db (Read)
    * Check position in the db has data:
      | ID          | 4080    |
      | Name        | Russia  |
      | CountryCode | RUS     |
      | District    | Rostov  |
      | Population  | 2000000 |
    * Close db connection

  Scenario: Change data in db (Update)
    * Change position in the db data:
      | ID          | 4080        |
      | Name        | Russia      |
      | CountryCode | RUS         |
      | District    | Vladivostok |
      | Population  | 1000000     |
    * Close db connection

  Scenario: Delete data in db (Delete)
    * Delete position in the db data:
      | ID | 4080 |
    * Close db connection