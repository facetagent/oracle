# Liquibase Executive for Oracle & APEX Environments

## 1. Overview
Liquibase is a database change‑management tool that enables versioned, automated, and repeatable schema evolution.
In Oracle/APEX environments, Liquibase manages the database schema, while APEX consumes the schema through its metadata.

👉 This document describes:
* Directory structure
* `liquibase.properties`
* `db.changelog-master.yaml`
* Changelog organization
* SQLcl integration
* Execution workflow

## 2. Recommended Project Structure

```
/project
│
├── liquibase.properties
│
├── changelog/
│   ├── db.changelog-master.yaml
│   ├── tables/
│   │   ├── customer.yaml
│   │   ├── orders.yaml
│   │   └── ...
│   ├── packages/
│   │   ├── pkg_customer.pkb
│   │   ├── pkg_customer.pks
│   │   └── ...
│   ├── data/
│   │   ├── initial-data.yaml
│   │   └── reference-data.yaml
│   └── scripts/
│       ├── custom-procedures.sql
│       └── triggers.sql
│
└── drivers/
    └── ojdbc11.jar
```

👉 Notes    
* The root folder contains liquibase.properties.
* All changelogs are under /changelog.
* Use subfolders (tables, data, scripts) for clarity and scalability.
* The master file (db.changelog-master.yaml) orchestrates all modules.

## 3. liquibase.properties
Example of liquibase.properties    
```
changeLogFile: changelog/db.changelog-master.yaml
logLevel: info
driver: oracle.jdbc.OracleDriver
```

👉 Notes    
* changeLogFile points to the master YAML file.
* classpath must reference the Oracle JDBC driver.

In case you need to change the location of liquibase.properties, you can do it with the command:
```
liquibase setproperty defaultsFile /path/to/liquibase.properties
```

## 4. db.changelog-master.yaml file

```
databaseChangeLog:

  - changeSet:
      id: 001-create-table-customer
      author: jean.daher
      changes:
        - sqlFile:
            path: ../src/table/customer.sql
            relativeToChangelogFile: true
            splitStatements: true
            stripComments: true
      rollback:
        - dropTable:
            tableName: CUSTOMER

  - changeSet:
      id: 002-create-package-pkg-customer-spec
      author: jean.daher
      runOnChange: true
      changes:
        - sqlFile:
            path: ../src/packages/pkg_customer.pks
            relativeToChangelogFile: true
            splitStatements: false
            endDelimiter: /

```

👉 Notes    
* The master file includes all module changelogs.
* Recommendation to use the concept of changeset, change the changeSet when you install in an environnement  
* Each module is isolated for maintainability.
* SQL scripts can be included directly.

⚠️ Changing a Liquibase changeSet is not trivial because Liquibase is designed to guarantee immutability and auditability of database changes.    
* 1- Never Modify an Already‑Executed ChangeSet    
 **Why?** Liquibase tracks executed changeSets by (id, author, path).
If you modify a changeSet that has already run, Liquibase will detect a checksum mismatch and refuse to continue.    
* 2- Use a New ChangeSet for Any Modification    
 **Rule** Every database change = one new changeSet.    
   Never rewrite history. Always append.
* 3- If You Must Modify a ChangeSet (rare cases)    
Only allowed if the changeSet has NOT been executed in any environment.    
* ✔️ Safe to modify changeSet when:    
You are still in development    
No environment (dev, test, prod) has applied the changeSet           
DATABASECHANGELOG does not contain the changeSet    
* ❌ Unsafe to modify changeSet when:    
The changeSet exists in any environment


❌ Do not use     
runOnChange: true



## 5. Example Table Changelog 
* see the examples in the repository 
 loadData: , sqlFile: , etc 


## 6. Running Liquibase (CLI)   

|Command | Description|
|---------------------------------------|-------------------------------------------|
| liquibase update-sql                  | Show SQL without executing                |
| liquibase update                      | Apply changes                             |
| liquibase rollback <tag>              | Rollback                                  |
| liquibase status --verbose            | Status                                    |
| liquibase update-sql --logLevel=debug | Show SQL without executing with debug     |
| liquibase status --verbose            | Status                                    |

## 7. Best Practices
Architecture
* Keep changelogs modular.
* Use YAML for readability.
* Store SQL scripts separately.

DevOps
* Externalize credentials.
* Use Liquibase in CI/CD pipelines.
* Tag releases for rollback.

Oracle/APEX
* Liquibase manages the schema.
* APEX consumes the schema automatically.
* No HQL/HQLC involved.

## 8. Versioning Strategy
Example:    
2024-09-01-01-create-customer-table.yaml
2024-09-01-02-insert-initial-data.yaml
2024-09-02-01-add-orders-table.yaml
2024-09-03-01-add-procedures.sql

Notes
* Use date‑based IDs.
* Keep authorship consistent.
* One changeSet = one atomic change.
