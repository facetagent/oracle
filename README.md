# oracle

Oracle Database `dbapp` project, managed with [Liquibase](https://www.liquibase.org/).

## Structure

- `src/table/customer.sql` — DDL for the `CUSTOMER` table
- `src/packages/pkg_customer.pks` / `.pkb` — `pkg_customer` package spec/body
- `changelog/db.changelog-master.yaml` — Liquibase master changelog (creates the table, installs the package, seeds 3 sample rows)
- `liquibase.properties` — Liquibase CLI connection config (update `url`/`username`/`password` for your environment)

## Usage

Requires the [Liquibase CLI](https://www.liquibase.org/download) and the Oracle JDBC driver (`ojdbc11.jar`) available on the classpath (see the `classpath` entry in `liquibase.properties`).

```
liquibase update
```

To preview the generated SQL without applying it:

```
liquibase update-sql
```

To roll back the last changeset:

```
liquibase rollback-count 1
```

