---
scope: learn
draft: true
---


# Tutorial

This is a step-by-step tutorial that shows how to build and connect to Calcite. It uses a simple adapter that makes a directory of CSV files appear to be a schema containing tables. Calcite does the rest, and provides a full SQL interface.

Calcite-example-CSV is a fully functional adapter for Calcite that reads text files in [CSV (comma-separated values)](https://en.wikipedia.org/wiki/Comma-separated_values) format. It is remarkable that a couple of hundred lines of Java code are sufficient to provide full SQL query capability.

CSV also serves as a template for building adapters to other data formats. Even though there are not many lines of code, it covers several important concepts:

-   user-defined schema using SchemaFactory and Schema interfaces;
-   declaring schemas in a model JSON file;
-   declaring views in a model JSON file;
-   user-defined table using the Table interface;
-   determining the record type of a table;
-   a simple implementation of Table, using the ScannableTable interface, that enumerates all rows directly;
-   a more advanced implementation that implements FilterableTable, and can filter out rows according to simple predicates;
-   advanced implementation of Table, using TranslatableTable, that translates to relational operators using planner rules.

## Download and build
[Permalink](https://calcite.apache.org/docs/tutorial.html#download-and-build "Permalink")

You need Java (version 8, 9 or 10) and Git.

```bash
$ git clone https://github.com/apache/calcite.git
$ cd calcite/example/csv
$ ./sqlline
```

## First queries
[Permalink](https://calcite.apache.org/docs/tutorial.html#first-queries "Permalink")

Now let’s connect to Calcite using [sqlline](https://github.com/julianhyde/sqlline), a SQL shell that is included in this project.

```bash
$ ./sqlline
sqlline> !connect jdbc:calcite:model=src/test/resources/model.json admin admin
```

(If you are running Windows, the command is `sqlline.bat`.)

Execute a metadata query:

```bash
sqlline> !tables
+-----------+-------------+------------+--------------+---------+----------+------------+-----------+---------------------------+----------------+
| TABLE_CAT | TABLE_SCHEM | TABLE_NAME |  TABLE_TYPE  | REMARKS | TYPE_CAT | TYPE_SCHEM | TYPE_NAME | SELF_REFERENCING_COL_NAME | REF_GENERATION |
+-----------+-------------+------------+--------------+---------+----------+------------+-----------+---------------------------+----------------+
|           | SALES       | DEPTS      | TABLE        |         |          |            |           |                           |                |
|           | SALES       | EMPS       | TABLE        |         |          |            |           |                           |                |
|           | SALES       | SDEPTS     | TABLE        |         |          |            |           |                           |                |
|           | metadata    | COLUMNS    | SYSTEM TABLE |         |          |            |           |                           |                |
|           | metadata    | TABLES     | SYSTEM TABLE |         |          |            |           |                           |                |
+-----------+-------------+------------+--------------+---------+----------+------------+-----------+---------------------------+----------------+
```

(JDBC experts, note: sqlline’s `!tables` command is just executing [`DatabaseMetaData.getTables()`](https://docs.oracle.com/javase/7/docs/api/java/sql/DatabaseMetaData.html#getTables(java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String%5B%5D)) behind the scenes. It has other commands to query JDBC metadata, such as `!columns` and `!describe`.)

As you can see there are 5 tables in the system: tables `EMPS`, `DEPTS` and `SDEPTS` in the current `SALES` schema, and `COLUMNS` and `TABLES` in the system `metadata` schema. The system tables are always present in Calcite, but the other tables are provided by the specific implementation of the schema; in this case, the `EMPS`, `DEPTS` and `SDEPTS` tables are based on the `EMPS.csv.gz`, `DEPTS.csv` and `SDEPTS.csv` files in the `resources/sales` directory.

Let’s execute some queries on those tables, to show that Calcite is providing a full implementation of SQL. First, a table scan:

```bash
sqlline> SELECT * FROM emps;
+-------+-------+--------+--------+---------------+-------+------+---------+---------+------------+
| EMPNO | NAME  | DEPTNO | GENDER |     CITY      | EMPID | AGE  | SLACKER | MANAGER |  JOINEDAT  |
+-------+-------+--------+--------+---------------+-------+------+---------+---------+------------+
| 100   | Fred  | 10     |        |               | 30    | 25   | true    | false   | 1996-08-03 |
| 110   | Eric  | 20     | M      | San Francisco | 3     | 80   |         | false   | 2001-01-01 |
| 110   | John  | 40     | M      | Vancouver     | 2     | null | false   | true    | 2002-05-03 |
| 120   | Wilma | 20     | F      |               | 1     | 5    |         | true    | 2005-09-07 |
| 130   | Alice | 40     | F      | Vancouver     | 2     | null | false   | true    | 2007-01-01 |
+-------+-------+--------+--------+---------------+-------+------+---------+---------+------------+
```

Now JOIN and GROUP BY:

```bash
sqlline> SELECT d.name, COUNT(*)
. . . .> FROM emps AS e JOIN depts AS d ON e.deptno = d.deptno
. . . .> GROUP BY d.name;
+------------+---------+
|    NAME    | EXPR$1  |
+------------+---------+
| Sales      | 1       |
| Marketing  | 2       |
+------------+---------+
```

Last, the VALUES operator generates a single row, and is a convenient way to test expressions and SQL built-in functions:

```bash
sqlline> VALUES CHAR_LENGTH('Hello, ' || 'world!');
+---------+
| EXPR$0  |
+---------+
| 13      |
+---------+
```

Calcite has many other SQL features. We don’t have time to cover them here. Write some more queries to experiment.

## Schema discovery
[Permalink](https://calcite.apache.org/docs/tutorial.html#schema-discovery "Permalink")

Now, how did Calcite find these tables? Remember, core Calcite does not know anything about CSV files. (As a “database without a storage layer”, Calcite doesn’t know about any file formats.) Calcite knows about those tables because we told it to run code in the calcite-example-csv project.

There are a couple of steps in that chain. First, we define a schema based on a schema factory class in a model file. Then the schema factory creates a schema, and the schema creates several tables, each of which knows how to get data by scanning a CSV file. Last, after Calcite has parsed the query and planned it to use those tables, Calcite invokes the tables to read the data as the query is being executed. Now let’s look at those steps in more detail.

On the JDBC connect string we gave the path of a model in JSON format. Here is the model:

```json
{
  version: '1.0',
  defaultSchema: 'SALES',
  schemas: [
    {
      name: 'SALES',
      type: 'custom',
      factory: 'org.apache.calcite.adapter.csv.CsvSchemaFactory',
      operand: {
        directory: 'sales'
      }
    }
  ]
}
```

The model defines a single schema called ‘SALES’. The schema is powered by a plugin class, [org.apache.calcite.adapter.csv.CsvSchemaFactory](https://github.com/apache/calcite/blob/master/example/csv/src/main/java/org/apache/calcite/adapter/csv/CsvSchemaFactory.java), which is part of the calcite-example-csv project and implements the Calcite interface [SchemaFactory](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/SchemaFactory.html). Its `create` method instantiates a schema, passing in the `directory` argument from the model file:

```java
public Schema create(SchemaPlus parentSchema, String name,
    Map<String, Object> operand) {
  String directory = (String) operand.get("directory");
  String flavorName = (String) operand.get("flavor");
  CsvTable.Flavor flavor;
  if (flavorName == null) {
    flavor = CsvTable.Flavor.SCANNABLE;
  } else {
    flavor = CsvTable.Flavor.valueOf(flavorName.toUpperCase());
  }
  return new CsvSchema(
      new File(directory),
      flavor);
}
```

Driven by the model, the schema factory instantiates a single schema called ‘SALES’. The schema is an instance of [org.apache.calcite.adapter.csv.CsvSchema](https://github.com/apache/calcite/blob/master/example/csv/src/main/java/org/apache/calcite/adapter/csv/CsvSchema.java) and implements the Calcite interface [Schema](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/Schema.html).

A schema’s job is to produce a list of tables. (It can also list sub-schemas and table-functions, but these are advanced features and calcite-example-csv does not support them.) The tables implement Calcite’s [Table](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/Table.html) interface. `CsvSchema` produces tables that are instances of [CsvTable](https://github.com/apache/calcite/blob/master/example/csv/src/main/java/org/apache/calcite/adapter/csv/CsvTable.java) and its sub-classes.

Here is the relevant code from `CsvSchema`, overriding the [`getTableMap()`](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/impl/AbstractSchema.html#getTableMap()) method in the `AbstractSchema` base class.

```java
protected Map<String, Table> getTableMap() {
  // Look for files in the directory ending in ".csv", ".csv.gz", ".json",
  // ".json.gz".
  File[] files = directoryFile.listFiles(
      new FilenameFilter() {
        public boolean accept(File dir, String name) {
          final String nameSansGz = trim(name, ".gz");
          return nameSansGz.endsWith(".csv")
              || nameSansGz.endsWith(".json");
        }
      });
  if (files == null) {
    System.out.println("directory " + directoryFile + " not found");
    files = new File[0];
  }
  // Build a map from table name to table; each file becomes a table.
  final ImmutableMap.Builder<String, Table> builder = ImmutableMap.builder();
  for (File file : files) {
    String tableName = trim(file.getName(), ".gz");
    final String tableNameSansJson = trimOrNull(tableName, ".json");
    if (tableNameSansJson != null) {
      JsonTable table = new JsonTable(file);
      builder.put(tableNameSansJson, table);
      continue;
    }
    tableName = trim(tableName, ".csv");
    final Table table = createTable(file);
    builder.put(tableName, table);
  }
  return builder.build();
}

/** Creates different sub-type of table based on the "flavor" attribute. */
private Table createTable(File file) {
  switch (flavor) {
  case TRANSLATABLE:
    return new CsvTranslatableTable(file, null);
  case SCANNABLE:
    return new CsvScannableTable(file, null);
  case FILTERABLE:
    return new CsvFilterableTable(file, null);
  default:
    throw new AssertionError("Unknown flavor " + flavor);
  }
}
```

The schema scans the directory, finds all files with the appropriate extension, and creates tables for them. In this case, the directory is `sales` and contains files `EMPS.csv.gz`, `DEPTS.csv` and `SDEPTS.csv`, which these become the tables `EMPS`, `DEPTS` and `SDEPTS`.

## Tables and views in schemas
[Permalink](https://calcite.apache.org/docs/tutorial.html#tables-and-views-in-schemas "Permalink")

Note how we did not need to define any tables in the model; the schema generated the tables automatically.

You can define extra tables, beyond those that are created automatically, using the `tables` property of a schema.

Let’s see how to create an important and useful type of table, namely a view.

A view looks like a table when you are writing a query, but it doesn’t store data. It derives its result by executing a query. The view is expanded while the query is being planned, so the query planner can often perform optimizations like removing expressions from the SELECT clause that are not used in the final result.

Here is a schema that defines a view:

```json
{
  version: '1.0',
  defaultSchema: 'SALES',
  schemas: [
    {
      name: 'SALES',
      type: 'custom',
      factory: 'org.apache.calcite.adapter.csv.CsvSchemaFactory',
      operand: {
        directory: 'sales'
      },
      tables: [
        {
          name: 'FEMALE_EMPS',
          type: 'view',
          sql: 'SELECT * FROM emps WHERE gender = \'F\''
        }
      ]
    }
  ]
}
```

The line `type: 'view'` tags `FEMALE_EMPS` as a view, as opposed to a regular table or a custom table. Note that single-quotes within the view definition are escaped using a back-slash, in the normal way for JSON.

JSON doesn’t make it easy to author long strings, so Calcite supports an alternative syntax. If your view has a long SQL statement, you can instead supply a list of lines rather than a single string:

```json
{
  name: 'FEMALE_EMPS',
  type: 'view',
  sql: [
    'SELECT * FROM emps',
    'WHERE gender = \'F\''
  ]
}
```

Now we have defined a view, we can use it in queries just as if it were a table:

```sql
sqlline> SELECT e.name, d.name FROM female_emps AS e JOIN depts AS d on e.deptno = d.deptno;
+--------+------------+
|  NAME  |    NAME    |
+--------+------------+
| Wilma  | Marketing  |
+--------+------------+
```

## Custom tables
[Permalink](https://calcite.apache.org/docs/tutorial.html#custom-tables "Permalink")

Custom tables are tables whose implementation is driven by user-defined code. They don’t need to live in a custom schema.

There is an example in `model-with-custom-table.json`:

```json
{
  version: '1.0',
  defaultSchema: 'CUSTOM_TABLE',
  schemas: [
    {
      name: 'CUSTOM_TABLE',
      tables: [
        {
          name: 'EMPS',
          type: 'custom',
          factory: 'org.apache.calcite.adapter.csv.CsvTableFactory',
          operand: {
            file: 'sales/EMPS.csv.gz',
            flavor: "scannable"
          }
        }
      ]
    }
  ]
}
```

We can query the table in the usual way:

```sql
sqlline> !connect jdbc:calcite:model=src/test/resources/model-with-custom-table.json admin admin
sqlline> SELECT empno, name FROM custom_table.emps;
+--------+--------+
| EMPNO  |  NAME  |
+--------+--------+
| 100    | Fred   |
| 110    | Eric   |
| 110    | John   |
| 120    | Wilma  |
| 130    | Alice  |
+--------+--------+
```

The schema is a regular one, and contains a custom table powered by [org.apache.calcite.adapter.csv.CsvTableFactory](https://github.com/apache/calcite/blob/master/example/csv/src/main/java/org/apache/calcite/adapter/csv/CsvTableFactory.java), which implements the Calcite interface [TableFactory](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/TableFactory.html). Its `create` method instantiates a `CsvScannableTable`, passing in the `file` argument from the model file:

```java
public CsvTable create(SchemaPlus schema, String name,
    Map<String, Object> map, RelDataType rowType) {
  String fileName = (String) map.get("file");
  final File file = new File(fileName);
  final RelProtoDataType protoRowType =
      rowType != null ? RelDataTypeImpl.proto(rowType) : null;
  return new CsvScannableTable(file, protoRowType);
}
```

Implementing a custom table is often a simpler alternative to implementing a custom schema. Both approaches might end up creating a similar implementation of the `Table` interface, but for the custom table you don’t need to implement metadata discovery. (`CsvTableFactory` creates a `CsvScannableTable`, just as `CsvSchema` does, but the table implementation does not scan the filesystem for .csv files.)

Custom tables require more work for the author of the model (the author needs to specify each table and its file explicitly) but also give the author more control (say, providing different parameters for each table).

## Comments in models
[Permalink](https://calcite.apache.org/docs/tutorial.html#comments-in-models "Permalink")

Models can include comments using `/* ... */` and `//` syntax:

```json
{
  version: '1.0',
  /* Multi-line
     comment. */
  defaultSchema: 'CUSTOM_TABLE',
  // Single-line comment.
  schemas: [
    ..
  ]
}
```

(Comments are not standard JSON, but are a harmless extension.)

## Optimizing queries using planner rules
[Permalink](https://calcite.apache.org/docs/tutorial.html#optimizing-queries-using-planner-rules "Permalink")

The table implementations we have seen so far are fine as long as the tables don’t contain a great deal of data. But if your customer table has, say, a hundred columns and a million rows, you would rather that the system did not retrieve all of the data for every query. You would like Calcite to negotiate with the adapter and find a more efficient way of accessing the data.

This negotiation is a simple form of query optimization. Calcite supports query optimization by adding _planner rules_. Planner rules operate by looking for patterns in the query parse tree (for instance a project on top of a certain kind of table), and replacing the matched nodes in the tree by a new set of nodes which implement the optimization.

Planner rules are also extensible, like schemas and tables. So, if you have a data store that you want to access via SQL, you first define a custom table or schema, and then you define some rules to make the access efficient.

To see this in action, let’s use a planner rule to access a subset of columns from a CSV file. Let’s run the same query against two very similar schemas:

```sql
sqlline> !connect jdbc:calcite:model=src/test/resources/model.json admin admin
sqlline> explain plan for select name from emps;
+-----------------------------------------------------+
| PLAN                                                |
+-----------------------------------------------------+
| EnumerableCalc(expr#0..9=[{inputs}], NAME=[$t1])    |
|   EnumerableTableScan(table=[[SALES, EMPS]])        |
+-----------------------------------------------------+
sqlline> !connect jdbc:calcite:model=src/test/resources/smart.json admin admin
sqlline> explain plan for select name from emps;
+-----------------------------------------------------+
| PLAN                                                |
+-----------------------------------------------------+
| CsvTableScan(table=[[SALES, EMPS]], fields=[[1]])   |
+-----------------------------------------------------+
```

What causes the difference in plan? Let’s follow the trail of evidence. In the `smart.json` model file, there is just one extra line:

```json
flavor: "translatable"
```

This causes a `CsvSchema` to be created with `flavor = TRANSLATABLE`, and its `createTable` method creates instances of [CsvTranslatableTable](https://github.com/apache/calcite/blob/master/example/csv/src/main/java/org/apache/calcite/adapter/csv/CsvTranslatableTable.java) rather than a `CsvScannableTable`.

`CsvTranslatableTable` implements the `[TranslatableTable.toRel()](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/TranslatableTable.html#toRel())` method to create [CsvTableScan](https://github.com/apache/calcite/blob/master/example/csv/src/main/java/org/apache/calcite/adapter/csv/CsvTableScan.java). Table scans are the leaves of a query operator tree. The usual implementation is `[EnumerableTableScan](https://calcite.apache.org/javadocAggregate/org/apache/calcite/adapter/enumerable/EnumerableTableScan.html)`, but we have created a distinctive sub-type that will cause rules to fire.

Here is the rule in its entirety:

```java
public class CsvProjectTableScanRule
    extends RelRule<CsvProjectTableScanRule.Config> {
  /** Creates a CsvProjectTableScanRule. */
  protected CsvProjectTableScanRule(Config config) {
    super(config);
  }

  @Override public void onMatch(RelOptRuleCall call) {
    final LogicalProject project = call.rel(0);
    final CsvTableScan scan = call.rel(1);
    int[] fields = getProjectFields(project.getProjects());
    if (fields == null) {
      // Project contains expressions more complex than just field references.
      return;
    }
    call.transformTo(
        new CsvTableScan(
            scan.getCluster(),
            scan.getTable(),
            scan.csvTable,
            fields));
  }

  private int[] getProjectFields(List<RexNode> exps) {
    final int[] fields = new int[exps.size()];
    for (int i = 0; i < exps.size(); i++) {
      final RexNode exp = exps.get(i);
      if (exp instanceof RexInputRef) {
        fields[i] = ((RexInputRef) exp).getIndex();
      } else {
        return null; // not a simple projection
      }
    }
    return fields;
  }

  /** Rule configuration. */
  public interface Config extends RelRule.Config {
    Config DEFAULT = EMPTY
        .withOperandSupplier(b0 ->
            b0.operand(LogicalProject.class).oneInput(b1 ->
                b1.operand(CsvTableScan.class).noInputs()))
        .as(Config.class);

    @Override default CsvProjectTableScanRule toRule() {
      return new CsvProjectTableScanRule(this);
    }
}
```

The default instance of the rule resides in the `CsvRules` holder class:

```java
public abstract class CsvRules {
  public static final CsvProjectTableScanRule PROJECT_SCAN =
      CsvProjectTableScanRule.Config.DEFAULT.toRule();
}
```

The call to the `withOperandSupplier` method in the default configuration (the `DEFAULT` field in `interface Config`) declares the pattern of relational expressions that will cause the rule to fire. The planner will invoke the rule if it sees a `LogicalProject` whose sole input is a `CsvTableScan` with no inputs.

Variants of the rule are possible. For example, a different rule instance might instead match a `EnumerableProject` on a `CsvTableScan`.

The `onMatch` method generates a new relational expression and calls `[RelOptRuleCall.transformTo()](https://calcite.apache.org/javadocAggregate/org/apache/calcite/plan/RelOptRuleCall.html#transformTo(org.apache.calcite.rel.RelNode))` to indicate that the rule has fired successfully.

## The query optimization process
[Permalink](https://calcite.apache.org/docs/tutorial.html#the-query-optimization-process "Permalink")

There’s a lot to say about how clever Calcite’s query planner is, but we won’t say it here. The cleverness is designed to take the burden off you, the writer of planner rules.

First, Calcite doesn’t fire rules in a prescribed order. The query optimization process follows many branches of a branching tree, just like a chess playing program examines many possible sequences of moves. If rules A and B both match a given section of the query operator tree, then Calcite can fire both.

Second, Calcite uses cost in choosing between plans, but the cost model doesn’t prevent rules from firing which may seem to be more expensive in the short term.

Many optimizers have a linear optimization scheme. Faced with a choice between rule A and rule B, as above, such an optimizer needs to choose immediately. It might have a policy such as “apply rule A to the whole tree, then apply rule B to the whole tree”, or apply a cost-based policy, applying the rule that produces the cheaper result.

Calcite doesn’t require such compromises. This makes it simple to combine various sets of rules. If, say you want to combine rules to recognize materialized views with rules to read from CSV and JDBC source systems, you just give Calcite the set of all rules and tell it to go at it.

Calcite does use a cost model. The cost model decides which plan to ultimately use, and sometimes to prune the search tree to prevent the search space from exploding, but it never forces you to choose between rule A and rule B. This is important, because it avoids falling into local minima in the search space that are not actually optimal.

Also (you guessed it) the cost model is pluggable, as are the table and query operator statistics it is based upon. But that can be a subject for later.

## JDBC adapter
[Permalink](https://calcite.apache.org/docs/tutorial.html#jdbc-adapter "Permalink")

The JDBC adapter maps a schema in a JDBC data source as a Calcite schema.

For example, this schema reads from a MySQL “foodmart” database:

```json
{
  version: '1.0',
  defaultSchema: 'FOODMART',
  schemas: [
    {
      name: 'FOODMART',
      type: 'custom',
      factory: 'org.apache.calcite.adapter.jdbc.JdbcSchema$Factory',
      operand: {
        jdbcDriver: 'com.mysql.jdbc.Driver',
        jdbcUrl: 'jdbc:mysql://localhost/foodmart',
        jdbcUser: 'foodmart',
        jdbcPassword: 'foodmart'
      }
    }
  ]
}
```

(The FoodMart database will be familiar to those of you who have used the Mondrian OLAP engine, because it is Mondrian’s main test data set. To load the data set, follow [Mondrian’s installation instructions](https://mondrian.pentaho.com/documentation/installation.php#2_Set_up_test_data).)

**Current limitations**: The JDBC adapter currently only pushes down table scan operations; all other processing (filtering, joins, aggregations and so forth) occurs within Calcite. Our goal is to push down as much processing as possible to the source system, translating syntax, data types and built-in functions as we go. If a Calcite query is based on tables from a single JDBC database, in principle the whole query should go to that database. If tables are from multiple JDBC sources, or a mixture of JDBC and non-JDBC, Calcite will use the most efficient distributed query approach that it can.

## The cloning JDBC adapter
[Permalink](https://calcite.apache.org/docs/tutorial.html#the-cloning-jdbc-adapter "Permalink")

The cloning JDBC adapter creates a hybrid database. The data is sourced from a JDBC database but is read into in-memory tables the first time each table is accessed. Calcite evaluates queries based on those in-memory tables, effectively a cache of the database.

For example, the following model reads tables from a MySQL “foodmart” database:

```json
{
  version: '1.0',
  defaultSchema: 'FOODMART_CLONE',
  schemas: [
    {
      name: 'FOODMART_CLONE',
      type: 'custom',
      factory: 'org.apache.calcite.adapter.clone.CloneSchema$Factory',
      operand: {
        jdbcDriver: 'com.mysql.jdbc.Driver',
        jdbcUrl: 'jdbc:mysql://localhost/foodmart',
        jdbcUser: 'foodmart',
        jdbcPassword: 'foodmart'
      }
    }
  ]
}
```

Another technique is to build a clone schema on top of an existing schema. You use the `source` property to reference a schema defined earlier in the model, like this:

```json
{
  version: '1.0',
  defaultSchema: 'FOODMART_CLONE',
  schemas: [
    {
      name: 'FOODMART',
      type: 'custom',
      factory: 'org.apache.calcite.adapter.jdbc.JdbcSchema$Factory',
      operand: {
        jdbcDriver: 'com.mysql.jdbc.Driver',
        jdbcUrl: 'jdbc:mysql://localhost/foodmart',
        jdbcUser: 'foodmart',
        jdbcPassword: 'foodmart'
      }
    },
    {
      name: 'FOODMART_CLONE',
      type: 'custom',
      factory: 'org.apache.calcite.adapter.clone.CloneSchema$Factory',
      operand: {
        source: 'FOODMART'
      }
    }
  ]
}
```

You can use this approach to create a clone schema on any type of schema, not just JDBC.

The cloning adapter isn’t the be-all and end-all. We plan to develop more sophisticated caching strategies, and a more complete and efficient implementation of in-memory tables, but for now the cloning JDBC adapter shows what is possible and allows us to try out our initial implementations.

## Further topics
[Permalink](https://calcite.apache.org/docs/tutorial.html#further-topics "Permalink")

There are many other ways to extend Calcite not yet described in this tutorial. The [adapter specification](https://calcite.apache.org/docs/adapter.html) describes the APIs involved.


# Algebra

Relational algebra is at the heart of Calcite. Every query is represented as a tree of relational operators. You can translate from SQL to relational algebra, or you can build the tree directly.

Planner rules transform expression trees using mathematical identities that preserve semantics. For example, it is valid to push a filter into an input of an inner join if the filter does not reference columns from the other input.

Calcite optimizes queries by repeatedly applying planner rules to a relational expression. A cost model guides the process, and the planner engine generates an alternative expression that has the same semantics as the original but a lower cost.

The planning process is extensible. You can add your own relational operators, planner rules, cost model, and statistics.

## Algebra builder
[Permalink](https://calcite.apache.org/docs/algebra.html#algebra-builder "Permalink")

The simplest way to build a relational expression is to use the algebra builder, [RelBuilder](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.html). Here is an example:

### TableScan
[Permalink](https://calcite.apache.org/docs/algebra.html#tablescan "Permalink")

```java
final FrameworkConfig config;
final RelBuilder builder = RelBuilder.create(config);
final RelNode node = builder
  .scan("EMP")
  .build();
System.out.println(RelOptUtil.toString(node));
```

(You can find the full code for this and other examples in [RelBuilderExample.java](https://github.com/apache/calcite/blob/master/core/src/test/java/org/apache/calcite/examples/RelBuilderExample.java).)

The code prints

```text
LogicalTableScan(table=[[scott, EMP]])
```

It has created a scan of the `EMP` table; equivalent to the SQL

```sql
SELECT *
FROM scott.EMP;
```

### Adding a Project
[Permalink](https://calcite.apache.org/docs/algebra.html#adding-a-project "Permalink")

Now, let’s add a Project, the equivalent of

```sql
SELECT ename, deptno
FROM scott.EMP;
```

We just add a call to the `project` method before calling `build`:

```java
final RelNode node = builder
  .scan("EMP")
  .project(builder.field("DEPTNO"), builder.field("ENAME"))
  .build();
System.out.println(RelOptUtil.toString(node));
```

and the output is

```text
LogicalProject(DEPTNO=[$7], ENAME=[$1])
  LogicalTableScan(table=[[scott, EMP]])
```

The two calls to `builder.field` create simple expressions that return the fields from the input relational expression, namely the TableScan created by the `scan` call.

Calcite has converted them to field references by ordinal, `$7` and `$1`.

### Adding a Filter and Aggregate
[Permalink](https://calcite.apache.org/docs/algebra.html#adding-a-filter-and-aggregate "Permalink")

A query with an Aggregate, and a Filter:

```java
final RelNode node = builder
  .scan("EMP")
  .aggregate(builder.groupKey("DEPTNO"),
      builder.count(false, "C"),
      builder.sum(false, "S", builder.field("SAL")))
  .filter(
      builder.call(SqlStdOperatorTable.GREATER_THAN,
          builder.field("C"),
          builder.literal(10)))
  .build();
System.out.println(RelOptUtil.toString(node));
```

is equivalent to SQL

```sql
SELECT deptno, count(*) AS c, sum(sal) AS s
FROM emp
GROUP BY deptno
HAVING count(*) > 10
```

and produces

```text
LogicalFilter(condition=[>($1, 10)])
  LogicalAggregate(group=[{7}], C=[COUNT()], S=[SUM($5)])
    LogicalTableScan(table=[[scott, EMP]])
```

### Push and pop
[Permalink](https://calcite.apache.org/docs/algebra.html#push-and-pop "Permalink")

The builder uses a stack to store the relational expression produced by one step and pass it as an input to the next step. This allows the methods that produce relational expressions to produce a builder.

Most of the time, the only stack method you will use is `build()`, to get the last relational expression, namely the root of the tree.

Sometimes the stack becomes so deeply nested it gets confusing. To keep things straight, you can remove expressions from the stack. For example, here we are building a bushy join:

```text
.
               join
             /      \
        join          join
      /      \      /      \
CUSTOMERS ORDERS LINE_ITEMS PRODUCTS
```

We build it in three stages. Store the intermediate results in variables `left` and `right`, and use `push()` to put them back on the stack when it is time to create the final `Join`:

```java
final RelNode left = builder
  .scan("CUSTOMERS")
  .scan("ORDERS")
  .join(JoinRelType.INNER, "ORDER_ID")
  .build();

final RelNode right = builder
  .scan("LINE_ITEMS")
  .scan("PRODUCTS")
  .join(JoinRelType.INNER, "PRODUCT_ID")
  .build();

final RelNode result = builder
  .push(left)
  .push(right)
  .join(JoinRelType.INNER, "ORDER_ID")
  .build();
```

### Switch Convention
[Permalink](https://calcite.apache.org/docs/algebra.html#switch-convention "Permalink")

The default RelBuilder creates logical RelNode without coventions. But you could switch to use a different convention through `adoptConvention()`:

```java
final RelNode result = builder
  .push(input)
  .adoptConvention(EnumerableConvention.INSTANCE)
  .sort(toCollation)
  .build();
```

In this case, we create an EnumerableSort on top of the input RelNode.

### Field names and ordinals
[Permalink](https://calcite.apache.org/docs/algebra.html#field-names-and-ordinals "Permalink")

You can reference a field by name or ordinal.

Ordinals are zero-based. Each operator guarantees the order in which its output fields occur. For example, `Project` returns the fields generated by each of the scalar expressions.

The field names of an operator are guaranteed to be unique, but sometimes that means that the names are not exactly what you expect. For example, when you join EMP to DEPT, one of the output fields will be called DEPTNO and another will be called something like DEPTNO_1.

Some relational expression methods give you more control over field names:

-   `project` lets you wrap expressions using `alias(expr, fieldName)`. It removes the wrapper but keeps the suggested name (as long as it is unique).
-   `values(String[] fieldNames, Object... values)` accepts an array of field names. If any element of the array is null, the builder will generate a unique name.

If an expression projects an input field, or a cast of an input field, it will use the name of that input field.

Once the unique field names have been assigned, the names are immutable. If you have a particular `RelNode` instance, you can rely on the field names not changing. In fact, the whole relational expression is immutable.

But if a relational expression has passed through several rewrite rules (see [RelOptRule](https://calcite.apache.org/javadocAggregate/org/apache/calcite/plan/RelOptRule.html)), the field names of the resulting expression might not look much like the originals. At that point it is better to reference fields by ordinal.

When you are building a relational expression that accepts multiple inputs, you need to build field references that take that into account. This occurs most often when building join conditions.

Suppose you are building a join on EMP, which has 8 fields [EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO] and DEPT, which has 3 fields [DEPTNO, DNAME, LOC]. Internally, Calcite represents those fields as offsets into a combined input row with 11 fields: the first field of the left input is field #0 (0-based, remember), and the first field of the right input is field #8.

But through the builder API, you specify which field of which input. To reference “SAL”, internal field #5, write `builder.field(2, 0, "SAL")`, `builder.field(2, "EMP", "SAL")`, or `builder.field(2, 0, 5)`. This means “the field #5 of input #0 of two inputs”. (Why does it need to know that there are two inputs? Because they are stored on the stack; input #1 is at the top of the stack, and input #0 is below it. If we did not tell the builder that were two inputs, it would not know how deep to go for input #0.)

Similarly, to reference “DNAME”, internal field #9 (8 + 1), write `builder.field(2, 1, "DNAME")`, `builder.field(2, "DEPT", "DNAME")`, or `builder.field(2, 1, 1)`.

### Recursive Queries
[Permalink](https://calcite.apache.org/docs/algebra.html#recursive-queries "Permalink")

Warning: The current API is experimental and subject to change without notice. A SQL recursive query, e.g. this one that generates the sequence 1, 2, 3, …10:

```sql
WITH RECURSIVE aux(i) AS (
  VALUES (1)
  UNION ALL
  SELECT i+1 FROM aux WHERE i < 10
)
SELECT * FROM aux
```

can be generated using a scan on a TransientTable and a RepeatUnion:

```java
final RelNode node = builder
  .values(new String[] { "i" }, 1)
  .transientScan("aux")
  .filter(
      builder.call(
          SqlStdOperatorTable.LESS_THAN,
          builder.field(0),
          builder.literal(10)))
  .project(
      builder.call(
          SqlStdOperatorTable.PLUS,
          builder.field(0),
          builder.literal(1)))
  .repeatUnion("aux", true)
  .build();
System.out.println(RelOptUtil.toString(node));
```

which produces:

```text
LogicalRepeatUnion(all=[true])
  LogicalTableSpool(readType=[LAZY], writeType=[LAZY], tableName=[aux])
    LogicalValues(tuples=[[{ 1 }]])
  LogicalTableSpool(readType=[LAZY], writeType=[LAZY], tableName=[aux])
    LogicalProject($f0=[+($0, 1)])
      LogicalFilter(condition=[<($0, 10)])
        LogicalTableScan(table=[[aux]])
```

### API summary
[Permalink](https://calcite.apache.org/docs/algebra.html#api-summary "Permalink")

#### Relational operators
[Permalink](https://calcite.apache.org/docs/algebra.html#relational-operators "Permalink")

The following methods create a relational expression ([RelNode](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/RelNode.html)), push it onto the stack, and return the `RelBuilder`.

METHOD

DESCRIPTION

`scan(tableName)`

Creates a [TableScan](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/TableScan.html).

`functionScan(operator, n, expr...)`  
`functionScan(operator, n, exprList)`

Creates a [TableFunctionScan](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/TableFunctionScan.html) of the `n` most recent relational expressions.

`transientScan(tableName [, rowType])`

Creates a [TableScan](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/TableScan.html) on a [TransientTable](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/TransientTable.html) with the given type (if not specified, the most recent relational expression’s type will be used).

`values(fieldNames, value...)`  
`values(rowType, tupleList)`

Creates a [Values](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Values.html).

`filter([variablesSet, ] exprList)`  
`filter([variablesSet, ] expr...)`

Creates a [Filter](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Filter.html) over the AND of the given predicates; if `variablesSet` is specified, the predicates may reference those variables.

`project(expr...)`  
`project(exprList [, fieldNames])`

Creates a [Project](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Project.html). To override the default name, wrap expressions using `alias`, or specify the `fieldNames` argument.

`projectPlus(expr...)`  
`projectPlus(exprList)`

Variant of `project` that keeps original fields and appends the given expressions.

`projectExcept(expr...)`  
`projectExcept(exprList)`

Variant of `project` that keeps original fields and removes the given expressions.

`permute(mapping)`

Creates a [Project](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Project.html) that permutes the fields using `mapping`.

`convert(rowType [, rename])`

Creates a [Project](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Project.html) that converts the fields to the given types, optionally also renaming them.

`aggregate(groupKey, aggCall...)`  
`aggregate(groupKey, aggCallList)`

Creates an [Aggregate](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Aggregate.html).

`distinct()`

Creates an [Aggregate](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Aggregate.html) that eliminates duplicate records.

`pivot(groupKey, aggCalls, axes, values)`

Adds a pivot operation, implemented by generating an [Aggregate](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Aggregate.html) with a column for each combination of measures and values

`unpivot(includeNulls, measureNames, axisNames, axisMap)`

Adds an unpivot operation, implemented by generating a [Join](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Join.html) to a [Values](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Values.html) that converts each row to several rows

`sort(fieldOrdinal...)`  
`sort(expr...)`  
`sort(exprList)`

Creates a [Sort](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Sort.html).  
  
In the first form, field ordinals are 0-based, and a negative ordinal indicates descending; for example, -2 means field 1 descending.  
  
In the other forms, you can wrap expressions in `as`, `nullsFirst` or `nullsLast`.

`sortLimit(offset, fetch, expr...)`  
`sortLimit(offset, fetch, exprList)`

Creates a [Sort](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Sort.html) with offset and limit.

`limit(offset, fetch)`

Creates a [Sort](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Sort.html) that does not sort, only applies with offset and limit.

`exchange(distribution)`

Creates an [Exchange](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Exchange.html).

`sortExchange(distribution, collation)`

Creates a [SortExchange](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/SortExchange.html).

`correlate(joinType, correlationId, requiredField...)`  
`correlate(joinType, correlationId, requiredFieldList)`

Creates a [Correlate](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Correlate.html) of the two most recent relational expressions, with a variable name and required field expressions for the left relation.

`join(joinType, expr...)`  
`join(joinType, exprList)`  
`join(joinType, fieldName...)`

Creates a [Join](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Join.html) of the two most recent relational expressions.  
  
The first form joins on a boolean expression (multiple conditions are combined using AND).  
  
The last form joins on named fields; each side must have a field of each name.

`semiJoin(expr)`

Creates a [Join](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Join.html) with SEMI join type of the two most recent relational expressions.

`antiJoin(expr)`

Creates a [Join](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Join.html) with ANTI join type of the two most recent relational expressions.

`union(all [, n])`

Creates a [Union](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Union.html) of the `n` (default two) most recent relational expressions.

`intersect(all [, n])`

Creates an [Intersect](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Intersect.html) of the `n` (default two) most recent relational expressions.

`minus(all)`

Creates a [Minus](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Minus.html) of the two most recent relational expressions.

`repeatUnion(tableName, all [, n])`

Creates a [RepeatUnion](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/RepeatUnion.html) associated to a [TransientTable](https://calcite.apache.org/javadocAggregate/org/apache/calcite/schema/TransientTable.html) of the two most recent relational expressions, with `n` maximum number of iterations (default -1, i.e. no limit).

`snapshot(period)`

Creates a [Snapshot](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Snapshot.html) of the given snapshot period.

`match(pattern, strictStart,` `strictEnd, patterns, measures,` `after, subsets, allRows,` `partitionKeys, orderKeys,` `interval)`

Creates a [Match](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/Match.html).

Argument types:

-   `expr`, `interval` [RexNode](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexNode.html)
-   `expr...`, `requiredField...` Array of [RexNode](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexNode.html)
-   `exprList`, `measureList`, `partitionKeys`, `orderKeys`, `requiredFieldList` Iterable of [RexNode](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexNode.html)
-   `fieldOrdinal` Ordinal of a field within its row (starting from 0)
-   `fieldName` Name of a field, unique within its row
-   `fieldName...` Array of String
-   `fieldNames` Iterable of String
-   `rowType` [RelDataType](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/type/RelDataType.html)
-   `groupKey` [RelBuilder.GroupKey](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.GroupKey.html)
-   `aggCall...` Array of [RelBuilder.AggCall](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.AggCall.html)
-   `aggCallList` Iterable of [RelBuilder.AggCall](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.AggCall.html)
-   `value...` Array of Object
-   `value` Object
-   `tupleList` Iterable of List of [RexLiteral](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexLiteral.html)
-   `all`, `distinct`, `strictStart`, `strictEnd`, `allRows` boolean
-   `alias` String
-   `correlationId` [CorrelationId](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/CorrelationId.html)
-   `variablesSet` Iterable of [CorrelationId](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/CorrelationId.html)
-   `varHolder` [Holder](https://calcite.apache.org/javadocAggregate/org/apache/calcite/util/Holder.html) of [RexCorrelVariable](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexCorrelVariable.html)
-   `patterns` Map whose key is String, value is [RexNode](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexNode.html)
-   `subsets` Map whose key is String, value is a sorted set of String
-   `distribution` [RelDistribution](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/RelDistribution.html)
-   `collation` [RelCollation](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/RelCollation.html)
-   `operator` [SqlOperator](https://calcite.apache.org/javadocAggregate/org/apache/calcite/sql/SqlOperator.html)
-   `joinType` [JoinRelType](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rel/core/JoinRelType.html)

The builder methods perform various optimizations, including:

-   `project` returns its input if asked to project all columns in order
-   `filter` flattens the condition (so an `AND` and `OR` may have more than 2 children), simplifies (converting say `x = 1 AND TRUE` to `x = 1`)
-   If you apply `sort` then `limit`, the effect is as if you had called `sortLimit`

There are annotation methods that add information to the top relational expression on the stack:

METHOD

DESCRIPTION

`as(alias)`

Assigns a table alias to the top relational expression on the stack

`variable(varHolder)`

Creates a correlation variable referencing the top relational expression

#### Stack methods
[Permalink](https://calcite.apache.org/docs/algebra.html#stack-methods "Permalink")

METHOD

DESCRIPTION

`build()`

Pops the most recently created relational expression off the stack

`push(rel)`

Pushes a relational expression onto the stack. Relational methods such as `scan`, above, call this method, but user code generally does not

`pushAll(collection)`

Pushes a collection of relational expressions onto the stack

`peek()`

Returns the relational expression most recently put onto the stack, but does not remove it

#### Scalar expression methods
[Permalink](https://calcite.apache.org/docs/algebra.html#scalar-expression-methods "Permalink")

The following methods return a scalar expression ([RexNode](https://calcite.apache.org/javadocAggregate/org/apache/calcite/rex/RexNode.html)).

Many of them use the contents of the stack. For example, `field("DEPTNO")` returns a reference to the “DEPTNO” field of the relational expression just added to the stack.

METHOD

DESCRIPTION

`literal(value)`

Constant

`field(fieldName)`

Reference, by name, to a field of the top-most relational expression

`field(fieldOrdinal)`

Reference, by ordinal, to a field of the top-most relational expression

`field(inputCount, inputOrdinal, fieldName)`

Reference, by name, to a field of the (`inputCount` - `inputOrdinal`)th relational expression

`field(inputCount, inputOrdinal, fieldOrdinal)`

Reference, by ordinal, to a field of the (`inputCount` - `inputOrdinal`)th relational expression

`field(inputCount, alias, fieldName)`

Reference, by table alias and field name, to a field at most `inputCount - 1` elements from the top of the stack

`field(alias, fieldName)`

Reference, by table alias and field name, to a field of the top-most relational expressions

`field(expr, fieldName)`

Reference, by name, to a field of a record-valued expression

`field(expr, fieldOrdinal)`

Reference, by ordinal, to a field of a record-valued expression

`fields(fieldOrdinalList)`

List of expressions referencing input fields by ordinal

`fields(mapping)`

List of expressions referencing input fields by a given mapping

`fields(collation)`

List of expressions, `exprList`, such that `sort(exprList)` would replicate collation

`call(op, expr...)`  
`call(op, exprList)`

Call to a function or operator

`and(expr...)`  
`and(exprList)`

Logical AND. Flattens nested ANDs, and optimizes cases involving TRUE and FALSE.

`or(expr...)`  
`or(exprList)`

Logical OR. Flattens nested ORs, and optimizes cases involving TRUE and FALSE.

`not(expr)`

Logical NOT

`equals(expr, expr)`

Equals

`isNull(expr)`

Checks whether an expression is null

`isNotNull(expr)`

Checks whether an expression is not null

`alias(expr, fieldName)`

Renames an expression (only valid as an argument to `project`)

`cast(expr, typeName)`  
`cast(expr, typeName, precision)`  
`cast(expr, typeName, precision, scale)`  

Converts an expression to a given type

`desc(expr)`

Changes sort direction to descending (only valid as an argument to `sort` or `sortLimit`)

`nullsFirst(expr)`

Changes sort order to nulls first (only valid as an argument to `sort` or `sortLimit`)

`nullsLast(expr)`

Changes sort order to nulls last (only valid as an argument to `sort` or `sortLimit`)

`cursor(n, input)`

Reference to `input`th (0-based) relational input of a `TableFunctionScan` with `n` inputs (see `functionScan`)

#### Sub-query methods
[Permalink](https://calcite.apache.org/docs/algebra.html#sub-query-methods "Permalink")

The following methods convert a sub-query into a scalar value (a `BOOLEAN` in the case of `in`, `exists`, `some`, `all`, `unique`; any scalar type for `scalarQuery`). an `ARRAY` for `arrayQuery`, a `MAP` for `mapQuery`, and a `MULTISET` for `multisetQuery`).

In all the following, `relFn` is a function that takes a `RelBuilder` argument and returns a `RelNode`. You typically implement it as a lambda; the method calls your code with a `RelBuilder` that has the correct context, and your code returns the `RelNode` that is to be the sub-query.

METHOD

DESCRIPTION

`all(expr, op, relFn)`

Returns whether _expr_ has a particular relation to all of the values of the sub-query

`arrayQuery(relFn)`

Returns the rows of a sub-query as an `ARRAY`

`exists(relFn)`

Tests whether sub-query is non-empty

`in(expr, relFn)`  
`in(exprList, relFn)`

Tests whether a value occurs in a sub-query

`mapQuery(relFn)`

Returns the rows of a sub-query as a `MAP`

`multisetQuery(relFn)`

Returns the rows of a sub-query as a `MULTISET`

`scalarQuery(relFn)`

Returns the value of the sole column of the sole row of a sub-query

`some(expr, op, relFn)`

Returns whether _expr_ has a particular relation to one or more of the values of the sub-query

`unique(relFn)`

Returns whether the rows of a sub-query are unique

#### Pattern methods
[Permalink](https://calcite.apache.org/docs/algebra.html#pattern-methods "Permalink")

The following methods return patterns for use in `match`.

METHOD

DESCRIPTION

`patternConcat(pattern...)`

Concatenates patterns

`patternAlter(pattern...)`

Alternates patterns

`patternQuantify(pattern, min, max)`

Quantifies a pattern

`patternPermute(pattern...)`

Permutes a pattern

`patternExclude(pattern)`

Excludes a pattern

#### Group key methods
[Permalink](https://calcite.apache.org/docs/algebra.html#group-key-methods "Permalink")

The following methods return a [RelBuilder.GroupKey](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.GroupKey.html).

METHOD

DESCRIPTION

`groupKey(fieldName...)`  
`groupKey(fieldOrdinal...)`  
`groupKey(expr...)`  
`groupKey(exprList)`

Creates a group key of the given expressions

`groupKey(exprList, exprListList)`

Creates a group key of the given expressions with grouping sets

`groupKey(bitSet [, bitSets])`

Creates a group key of the given input columns, with multiple grouping sets if `bitSets` is specified

#### Aggregate call methods
[Permalink](https://calcite.apache.org/docs/algebra.html#aggregate-call-methods "Permalink")

The following methods return an [RelBuilder.AggCall](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.AggCall.html).

METHOD

DESCRIPTION

`aggregateCall(op, expr...)`  
`aggregateCall(op, exprList)`

Creates a call to a given aggregate function

`count([ distinct, alias, ] expr...)`  
`count([ distinct, alias, ] exprList)`

Creates a call to the `COUNT` aggregate function

`countStar(alias)`

Creates a call to the `COUNT(*)` aggregate function

`sum([ distinct, alias, ] expr)`

Creates a call to the `SUM` aggregate function

`min([ alias, ] expr)`

Creates a call to the `MIN` aggregate function

`max([ alias, ] expr)`

Creates a call to the `MAX` aggregate function

To further modify the `AggCall`, call its methods:

METHOD

DESCRIPTION

`approximate(approximate)`

Allows approximate value for the aggregate of `approximate`

`as(alias)`

Assigns a column alias to this expression (see SQL `AS`)

`distinct()`

Eliminates duplicate values before aggregating (see SQL `DISTINCT`)

`distinct(distinct)`

Eliminates duplicate values before aggregating if `distinct`

`filter(expr)`

Filters rows before aggregating (see SQL `FILTER (WHERE ...)`)

`sort(expr...)`  
`sort(exprList)`

Sorts rows before aggregating (see SQL `WITHIN GROUP`)

`unique(expr...)`  
`unique(exprList)`

Makes rows unique before aggregating (see SQL `WITHIN DISTINCT`)

`over()`

Converts this `AggCall` into a windowed aggregate (see `OverCall` below)

#### Windowed aggregate call methods
[Permalink](https://calcite.apache.org/docs/algebra.html#windowed-aggregate-call-methods "Permalink")

To create an [RelBuilder.OverCall](https://calcite.apache.org/javadocAggregate/org/apache/calcite/tools/RelBuilder.OverCall.html), which represents a call to a windowed aggregate function, create an aggregate call and then call its `over()` method, for instance `count().over()`.

To further modify the `OverCall`, call its methods:

METHOD

DESCRIPTION

`rangeUnbounded()`

Creates an unbounded range-based window, `RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`

`rangeFrom(lower)`

Creates a range-based window bounded below, `RANGE BETWEEN lower AND CURRENT ROW`

`rangeTo(upper)`

Creates a range-based window bounded above, `RANGE BETWEEN CURRENT ROW AND upper`

`rangeBetween(lower, upper)`

Creates a range-based window, `RANGE BETWEEN lower AND upper`

`rowsUnbounded()`

Creates an unbounded row-based window, `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`

`rowsFrom(lower)`

Creates a row-based window bounded below, `ROWS BETWEEN lower AND CURRENT ROW`

`rowsTo(upper)`

Creates a row-based window bounded above, `ROWS BETWEEN CURRENT ROW AND upper`

`rowsBetween(lower, upper)`

Creates a rows-based window, `ROWS BETWEEN lower AND upper`

`partitionBy(expr...)`  
`partitionBy(exprList)`

Partitions the window on the given expressions (see SQL `PARTITION BY`)

`orderBy(expr...)`  
`sort(exprList)`

Sorts the rows in the window (see SQL `ORDER BY`)

`allowPartial(b)`

Sets whether to allow partial width windows; default true

`nullWhenCountZero(b)`

Sets whether whether the aggregate function should evaluate to null if no rows are in the window; default false

`as(alias)`

Assigns a column alias (see SQL `AS`) and converts this `OverCall` to a `RexNode`

`toRex()`

Converts this `OverCall` to a `RexNode`