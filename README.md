# Data Modelling DBT

#### DBT Data Modelling Exercise

{% embed url="https://gitbook.gitbook.io/exercice/UEBLwCS3bfW5lGGBSptk" %}

The raw data consists of users, company, and event, with the following entity-relationship diagram:

![Entity-realationship diagram](<.gitbook/assets/Screenshot 2022-04-10 at 19.19.36.png>)

#### DBT Models

A model is a `select` statement. Models are defined in `.sql` files, in our exercise we store our models our `models` directory.

#### 1. Past 30 days user activity table

The aim of this model is to easily access how many times a user performed the following events in the last 30 days:

* `space_create`
* `company_create`
* `edit_page_create`
* `collection_create`
* `space_install_gitsync`

**Result:** Please refer to `models/monthly_user_activity.sql`

#### 2. Past 30 days user activity table

The aim of this model is to easily plot the evolution of member count per company.&#x20;

**Result:** Please refer to `models/monthly_user_count.sql`
