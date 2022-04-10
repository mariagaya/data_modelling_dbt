# Data Modelling DBT

#### DBT Data Modelling Exercise

{% embed url="https://gitbook.gitbook.io/exercice/UEBLwCS3bfW5lGGBSptk" %}

#### DBT Models

A model is a `select` statement. Models are defined in `.sql` files, in our exercise we store our models our `models` directory.

#### 1. Past 30 days user activity table

The aim of this model is to easily access how many times a user performed the following events in the last 30 days:

* `space_create`
* `company_create`
* `edit_page_create`
* `collection_create`
* `space_install_gitsync`

```sql
CREATE TABLE XXXX
(
  user_id STRING,
  space_create_count as INT64,
  space_create_last_date as DATE,
  ...
  space_install_gitsync_count as INT64,
  space_install_gitsync_last_date as DATE
);
```

Result: Please refer to `models/monthly_user_activity.sql`

#### 2. Past 30 days user activity table
