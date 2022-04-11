# Data Modelling DBT

#### DBT Data Modelling Exercise

{% embed url="https://gitbook.gitbook.io/exercice/UEBLwCS3bfW5lGGBSptk" %}

The raw data consists of users, company, and event, with the following entity-relationship diagram:

![Entity-realationship diagram, the schema relationships need to be modified.](<.gitbook/assets/Screenshot 2022-04-10 at 19.19.36.png>)

#### DBT Models

A model is a `select` statement. Models are defined in `.sql` files, in our exercise we store our models our `models` directory. \
\
A `staging` directory has been created which goal is to enable a space the staging models. Staging models take raw data, and clean and prepare them for further analysis. \
\
_Note: It is clear that in this scenario we won't need to do many transformations neither cleaning, but is good to mantein a project structure._

#### 1. Past 30 days user activity table

The aim of this model is to easily access how many times a user performed the following events in the last 30 days:

* `space_create`
* `company_create`
* `edit_page_create`
* `collection_create`
* `space_install_gitsync`

As a result we need to display the count of events per user, and the last time the user executed each event.

**Result:** Please refer to `models/last_30_days_events.sql`

#### 2. Company evolution of members

The aim of this model is to easily plot the evolution of member count per company. We need to consider that user signup and also leave the company, so it is important to accumulate the registrations but also substract the customers that leave a company every month.

**Result:** Please refer to `models/monthly_user_count.sql`
