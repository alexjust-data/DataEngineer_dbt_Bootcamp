**Analytics Engineering with Airbnb - [ [dbt](https://www.getdbt.com/) ~ Data Build Tool ]**

- [Introduction](#introduction)
  - [Modern data Stack in the AI Era](#modern-data-stack-in-the-ai-era)
  - [slowly changing dimensions SCD](#slowly-changing-dimensions-scd)
  - [dbt™ Overview](#dbt-overview)
- [Project Overview (Analytics Engineering with Airbnb)](#project-overview-analytics-engineering-with-airbnb)
  - [resources](#resources)
  - [snowflake](#snowflake)
  - [Snowflake user creation](#snowflake-user-creation)
  - [Snowflake data import](#snowflake-data-import)
  - [dbt setup](#dbt-setup)
    - [VSC extension : vscode-dbt-power-user](#vsc-extension--vscode-dbt-power-user)
- [Data Flow - Overview](#data-flow---overview)
  - [Models](#models)
    - [Common Table Expression (CTE)](#common-table-expression-cte)
    - [Creating our first model: Airbnb listings](#creating-our-first-model-airbnb-listings)
  - [Materializations](#materializations)
    - [Model Dependencies and dbt's ref tag](#model-dependencies-and-dbts-ref-tag)
    - [Table type materialization \& Project-level Materialization config](#table-type-materialization--project-level-materialization-config)
    - [Incremental materialization](#incremental-materialization)
    - [Ephemeral materialization](#ephemeral-materialization)
  - [Seeds and Sources](#seeds-and-sources)
    - [Seeds](#seeds)
    - [Sources](#sources)
    - [Sources Freshness](#sources-freshness)
  - [Snapshots](#snapshots)
    - [Creating a Snapshot](#creating-a-snapshot)
  - [Learning objectives - Tests](#learning-objectives---tests)
    - [Implementing Generic Tests in `dim_Listings_Cleaned.sql`](#implementing-generic-tests-in-dim_listings_cleanedsql)
    - [Singular Tests](#singular-tests)
  - [Macros, custom tests and packages](#macros-custom-tests-and-packages)
    - [Installing Third-Party Packages](#installing-third-party-packages)
  - [Learning Objectives - Documentation](#learning-objectives---documentation)
    - [Writing and Exploring Basic Documentation](#writing-and-exploring-basic-documentation)
    - [Markdown-based Docs, Custom Overview Page and Assets](#markdown-based-docs-custom-overview-page-and-assets)

---
## Introduction

OBJECTIVES  
* Data-maturity model
* dbt and data architectures
* Data warehouses, data lakes, and lakehouses
* ETL and ELT procedures
* dbt fundamentals
* Analytics Engineering
  
![](img/1.png)

**ETL**
![](img/02.png)

**ELT**
So the world has changed, as you know, of storage costs like two cents these days for every one GB of data. So it was logical to reorganize the traditional ETL workflow.
![](img/03.png)
Data warehouses like Snowflake Redshift and BigQuery are extremely scalable and performant, so it makes sense to do two transformations inside the database rather than external processing layer.

**Data Warehouse**
storing structured data
![](img/04.png)
Typically, you interact with the data warehouse by executing SQL against it. So data warehouses is nothing more than a performance engine that lets us do analytics workloads on our data using sequel. 

**External Tables**
First of all, you pay for the compute nodes, whether they are used or they are not used. And we are not talking about lethal amounts here. In case you have large datasets, that's very pricey. Even if you're a data warehouse. Storage is underutilized as you have small amounts of data, but it requires high analytical workloads.

Second, you can set up auto scaling, but it does that does not necessarily mean you can scale to meet your peak workloads.

There is this concept called external tables.
![](img/06.png)
![](img/07.png)
We have the option to store large files outside of the data warehouse in, for example, Amazon S3 or blob storage. So we can decouple the compute component from the storage component. At this point, we can scale the compute and the storage independently from the data that warehousing the istances.

So now we handle the storage and compute for structured data, but what do we do in case we have unstructured data like images and video videos or text files? Data Lake.

**Data Lake**
unstructured or send structured
![](img/05.png)
You can think of a data lake as a repository where you can put all kinds of data ranging from Rome cleanest, unstructured, semi-structured and so on. It is like a very scalable fire system on premise, this will be called GFS or Hadoop distributed file system, but for cloud. There are others like Amazon S3 or Asia. Is your data lake storage Gen2 a.k.a. address to. 

The point of the data lake is to store files so they have no computer integrated. This means that if you're analytical, workloads increase. You can scale your compute instances independently from storage and your cloud provider will take care of handling external tables itself. If you use `Databricks` or `Snowflake`, these providers will store your data in the data lake by default. And they will only provide you with analytical clusters that you can set up the way you want.

**Data Lakehouse**

Emerged due to the limitations of data lakes. 
![](img/08.png)
It essentially combines the best features of data lakes and data warehouses. In the case of a lake house, we have very similar data structure and data management features that we have in our data warehouse. However, it sits on top of a low cost cloud storage.  What's great in a lake houses is the cost efficient storage provided by your cloud provider. Also, the acid transactional support so you can ensure consistency and that the scheme of the data is stored in a Lake House metal store. Additionally, you can evolve the schema of your tables without having to make a copy of the dataset. As for governance, you can control and authorize access to your data, and we'll get an interface with which you can connect to visitors to the Lake House. 

**ETL process**
The transformations and normalization typically happened in the staging area before the load of the application of the data or the cleansing of the data were performed. As storage prices were high.
![](img/09.png)


**ELT process**
We are now able to shift away from the ETL, extract, transform load data integration, transition of processes to extract loads, transform for easy,
![](img/10.png)

### Modern data Stack in the AI Era
![](img/11.png)
Fivetran and Stitch are one of the most popular extracts and those tools that we have available today. The transformation layer sits on top of a cloud data warehouse and it uses DVT. You have Looker as a BI tool, for example, and sensors for reverse ETL. 

Now, the modern data stack is structured differently than traditional legacy tools. For example, in a traditional data stack, your BI tool would not only handle visualizations but also act as a data warehouse with integrated storage. So, you would have done everything within your BI tool. These tools were massive and complicated. They were vertically integrated since they included storage within the data warehouse, and you performed visualizations in them as well. However, the modern data stack really flattens this out. It is a horizontally integrated set of tools that are fully managed, cloud-based, and both cheap and easy to use. Because corporations realize that data is a product in itself, we now see that DevOps tools are evolving. Not just tools but also practices are becoming part of this modern data stack space and are gaining a lot of popularity. Today, we perform data engineering and analytics engineering, which follow software engineering and DevOps best practices.

The modern data stack is essentially the productionization of the different layers of the data integration flow. DBT (Data Build Tool) plays a key role in this by enabling teams to perform data transformations inside the data warehouse. The creators of DBT developed it as a tool to streamline and standardize the transformation process, making it more efficient and integrated within the data workflow.

### slowly changing dimensions SCD

Think of these as particular data, but it changes rarely and unpredictably, requiring a specific approach to handle referential integrity. when data is changing the source database How that change is reflected in the corresponding data warehouse table decides what data is maintained for further accessibility by the business.
In some cases, storing history data might not be worthwhile, as it might have become obsolete or entirely useless. But for some businesses, historic facts might remain relevant in the future. For example, for historical analyses has simply erasing it would cause the loss of valuable data. There are a number of approaches to considering the data management and data warehousing of seeds called the seed types. Some acid types are used more frequently than others, and there is a reason for that. In the following steps, we will walk through SCD type zero to three and look at some benefits and drawbacks.

> **SCD Type 0**: We want to implement it if some detail may not become worthwhile to maintain anymore for the business.The dimension change is only applied to the source stable and is not transferred to the data warehouse stable.
> ![](img/12.png)
> * For Airbnb, think of a scenario when a property owner changes his specs, no, he was provided to Airbnb when he first joined the platform.
> Back in 2008, when Airbnb launched businesses, they still used tax numbers to some extent as Airbnb gathered these facts numbers of its clients. By 2010's faxing went entirely out of fashion. Hence, there is no point for Airbnb to apply changes to facts data in its data warehouses anymore. In this case, Airbnb will use seed type zero and simply keep updating the facts data column in the data warehouse table.
>

> **SCD Type 1** : In some cases, when a dying engine changes, only the new value could be important. The reason for the change could be that the original data has become obsolete. In this case, we want to make sure that the new value is transferred to the data warehouse. While there is no point in maintaining historical data. In these scenarios, SCD Type 1 will be our choice, which consists of applying the same dimension change to the corresponding record in a data warehouse as the change that was applied to the record in teh sourde table.
> ![](img/13.png)
> * When looking for accommodation on Airbnb, you can filter for accommodation with air conditioning, and property owners can provide whether they have air conditioning installed at their place. Now, imagine a situation when a property owner started marketing his flat on Airbnb a while ago, when his flat didn't have air conditioning. But since then he's stalled or decided to install air conditioning at his place to please customers, and therefore he updated his information of its listing to show that his base now has air conditioning installed.
> * For Airbnb, it is no longer relevant that the property did not used to have air conditioning.It only matters that it does now. And so Airbnb will use SCD Type 1 and apply the same data change to their records in the source and the data warehouse staple.

> **SCD Type 2** : There are also situations when both the current and the history data might be important for our business. Besides the current value, history data might also be used for reporting or could be necessary to maintain for future validation. The first approach revealed look at two tackling such a situation is SCD Type 2, when a dimension change leads to an additional rule being added to the data warehouse table four for the new data. But the original or previous data is maintained, so we have a whole overview of what happened. The benefit of actually type two is that all historical historical data is saved after each change, so all historic data remains recoverable from the data warehouse.
> ![](img/14.png)
> * Additional columns are added to each, according to data warehouse stable, to indicate the time range of validity of the data and to show whether the record contains the current data.
> * Consider rental pricing data for Airbnb property owners may increase or decrease their rental prices whenever they wish. Airbnb wants to perform detailed analysts on changes in the rental prices to understand the market, and so they must maintain all historical data on rental prices.
> * If a property owner changes the rental price of their flat on Airbnb, Airbnb will store both the current and historic rental price. In this case, using gas, the SCD Type 2 can be a good choice for Airbnb as it will transfer the current data to the data warehouse while also making sure historic data is maintained from SCD Type 2.
> * It becomes less obvious which day to use, so we will have to dive deeper into understanding versus best the purpose of what we are trying to achieve.
> * The benefit of SCD type two is that all historic data is maintained, and that is and that it remains easily accessible. But it also increases the amount of data stored. In cases where the number of records is very high to begin with, using SCD Type 2 might not be viable as it might make processing speed unreasonably high.
 

> **SCD Type 3** : 
> There can be scenarios been keeping some history data sufficient. For example, if processing speed is a concern. In these cases, we can decide to do a trade off between not maintaining or history data for the sake of keeping the number of records in our data warehouse stable lower. 
> In case of silly type three, Collins new set of additional rules are used for recording the dimension changes, this type will not maintain historic values other than the original and the current values. So if a dimension changes or it happens more than once, all in the original and the current values will be recoverable from the date of our house. 
> ![](img/15.png)
> * When looking for accommodation on Airbnb, you can choose between three different types of places: shared rooms, private rooms, and entire places. Now, imagine a property owner started renting a room as a private room. Let's say, some years later, they decide to move out and market their flat as an entire place. Airbnb may want to analyze how properties have had their type changed since joining the platform, but they don't really care about changes that are no longer valid. So, let's say this person who now rents out their entire place decides to move back and lease it as a shared room.
> * In this case, Airbnb no longer keeps the history of the private room, the way the place was listed originally. They only care about the room type that came right before the current one. So, in this case, you care about the fact that the entire place was listed. Therefore, Airbnb can decide to use SCD Type 3, adding additional columns to the data warehouse table to store both the original and the current type of the property. The benefit of Type 3 is that it keeps the number of records lower in the data warehouse table, which allows for more efficient processing.
> * On the other hand, it does not allow for maintaining all historical data and can make the data more difficult to comprehend, as it has to be specified which column contains the original and the current value.

### dbt™ Overview

In short **dbt** is the `T` in
![](img/03.png)
**dbt** doesn't or extract like [fivetran](https://www.fivetran.com/pricing) or [Stitch](https://www.stitchdata.com/), but it transforms data that's loaded in the data warehouse with SQL, select statements.

Let's say we are in a dark room, and your goal is to see what's happening in that room. On the one hand, you can light a candle, but it won't provide enough light to see the entire room. If there are others in the room with you, it will be rather hard for them to see. Once the candle burns out, you are back in the dark. This is a bit like executing a SQL statement: once it's done, it's done.

On the other hand, we now have the possibility to use something much stronger than a candle, like a spotlight, a softbox, or reflectors. These provide more than enough light to illuminate the entire room, allowing everyone to see what's going on. With this powerful lighting, we won't miss a single detail. We will have absolute visibility over every single corner. A spotlight is portable and can easily be moved or carried, and others can use it as well. Multiple people can work simultaneously in a fully illuminated room.

This is the kind of difference I personally feel when working on a **dbt** project. Using **dbt** is like using a spotlight: once you start using it, you'll think, "Wow, how did I not use this before?" DBT allows you to deploy your analytics while following software engineering best practices such as `modularity, portability, CI/CD testing, and documentation`.
![](img/16.png)
To bring it home: With DBT, you will build production-grade data pipelines. What makes it great is that you write your code, compile it to SQL, and execute your data transformations on Snowflake or another data warehouse. Your transformations are version-controlled, easily tested, and, on top of that, you are equipped with automatically built DAGs (Directed Acyclic Graphs) of all your models in your DBT project.

Since DBT interpolates the locations of all the models it generates, it allows you to create different environments like development or production, and you can effortlessly switch between the two. In terms of performance, DBT will take your models (i.e., SQL SELECT statements), understand the dependencies between them, craft a dependency order, and parallelize the way your models are built. And it will run arbitrary subgraph.

## Project Overview (Analytics Engineering with Airbnb)

You will act as if you were an analytics engineer at Airbnb. You’re responsible for all the data flow in Berlin, Germany. This role comes with a lot of responsibilities, so you will need to import your data into a data warehouse and then make this data available for tools like DBT. Then, you will need to clean the data, perform several transformations on it, and export it to BI tools. 

* Simulating the life of an Analytics Engineer in Airbnb. 
* Loading, Cleansing, Exposing data
* Writing test, automations and documentation
* Data source: Inside Airbnb: Berlin

The data we work with here is reliable data, and the data itself comes from the [Inside Airbnb page](https://insideairbnb.com/berlin/)

**Tech Stack**

* [dbt](https://www.getdbt.com/)
* [snowflake](https://www.snowflake.com/en/data-cloud/pricing-options/)
* [preset](https://preset.io/pricing/)

As you start as an analytics engineer in a company, there are several requirements you need to take care of:

**requirements**
>* Modeling changes are easy to follow and revert
>* Explicit dependencies between models
>* Explore dependencies between models
>* Data quality tests
>* Error reporting
>* Incremental load of fact tables
>* Track history of dimension tables
>* Easy-to-access documentation

You want to work in a system where monitoring changes are easy to follow and easy to revert.

* If you can make your model code, it helps a lot because you can version control it. You can track all the changes, collaborate, and revert if needed.
* As you have many steps in your data pipeline, with many views and features feeding and depending on each other, you want to ensure that these dependencies are explicit.
* The framework should know the order in which to execute different steps in your pipeline to achieve a well-transformed result and a good dataset ready for analytics.

Additionally, you want to ensure that these dependencies are not only explicit but also easy to overview.

* It should be easy to explore and understand these dependencies.
* When you build your pipeline, the tool should be able to expose these dependencies in an accessible way.

You also need to make sure that when your pipeline is running, you can test for data quality.

* Ensure your pipeline works as expected.
* If there are any errors, you want to get alerted somehow.

These are probably the basic requirements. As you progress in building out your business logic, you will have a few extra requirements.

* For example, you will have tables that are incremental. New events might come in, and you don't want to rebuild the entire dataset but only add new records at the end of the table.
* In some cases, you want to manage slowly changing dimensions, keeping the history of any changes so you can go back in time.

These are some of the main requirements of a data analytics tool, and DBT is great for managing these.
 
### resources

* [single markdown file](https://github.com/nordquant/complete-dbt-bootcamp-zero-to-hero/blob/main/_course_resources/course-resources.md)
* [dbt project's GitHub page](https://github.com/nordquant/complete-dbt-bootcamp-zero-to-hero)

### snowflake 


* snowflake [link](https://signup.snowflake.com/?utm_cta=trial-en-www-homepage-top-right-nav-ss-evg&_ga=2.74406678.547897382.1657561304-1006975775.1656432605&_gac=1.254279162.1656541671.Cj0KCQjw8O-VBhCpARIsACMvVLPE7vSFoPt6gqlowxPDlHT6waZ2_Kd3-4926XLVs0QvlzvTvIKg7pgaAqd2EALw_wcB)  
* snowflake edition : Standard  
* Provider : AWS Web Service  
* Place : Ohio  


Send you a link: https://boryss-qp53113.snowflakecomputing.com/console/login?activationToken=

Here we are at the Snowflake master user registration page. You see, this is the one which is some random string and the US is to dot IWC. `borysxs-qp53113.`

**Set up dbt's permissions in Snowflake and import our datasets**

Snowflake :
* `+ create : SQL WorkSheet`

![](img/18.png)

### Snowflake user creation

Copy these SQL statements into a Snowflake Worksheet, select all and execute them (i.e. pressing the play button).

If you see a Grant partially executed: privileges [REFERENCE_USAGE] not granted. message when you execute GRANT ALL ON DATABASE AIRBNB to ROLE transform, that's just an info message and you can ignore it.


```SQL
-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the `transform` role
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Create the default warehouse if necessary
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE=TRANSFORM
  DEFAULT_NAMESPACE='AIRBNB.RAW'
  COMMENT='DBT user used for data transformation';
GRANT ROLE TRANSFORM to USER dbt;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS AIRBNB;
CREATE SCHEMA IF NOT EXISTS AIRBNB.RAW;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM; 
GRANT ALL ON DATABASE AIRBNB to ROLE TRANSFORM;
GRANT ALL ON ALL SCHEMAS IN DATABASE AIRBNB to ROLE TRANSFORM;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE AIRBNB to ROLE TRANSFORM;
GRANT ALL ON ALL TABLES IN SCHEMA AIRBNB.RAW to ROLE TRANSFORM;
GRANT ALL ON FUTURE TABLES IN SCHEMA AIRBNB.RAW to ROLE TRANSFORM;
```

Select all and press the play button or pest control, enter.

### Snowflake data import

Copy these SQL statements into a Snowflake Worksheet, select all and execute them (i.e. pressing the play button).


```SQL
-- Set up the defaults
USE WAREHOUSE COMPUTE_WH;
USE DATABASE airbnb;
USE SCHEMA RAW;

-- Create our three tables and import the data from S3
CREATE OR REPLACE TABLE raw_listings
                    (id integer,
                     listing_url string,
                     name string,
                     room_type string,
                     minimum_nights integer,
                     host_id integer,
                     price string,
                     created_at datetime,
                     updated_at datetime);
                    
COPY INTO raw_listings (id,
                        listing_url,
                        name,
                        room_type,
                        minimum_nights,
                        host_id,
                        price,
                        created_at,
                        updated_at)
                   from 's3://dbtlearn/listings.csv'
                    FILE_FORMAT = (type = 'CSV' skip_header = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '"');
                    

CREATE OR REPLACE TABLE raw_reviews
                    (listing_id integer,
                     date datetime,
                     reviewer_name string,
                     comments string,
                     sentiment string);
                    
COPY INTO raw_reviews (listing_id, date, reviewer_name, comments, sentiment)
                   from 's3://dbtlearn/reviews.csv'
                    FILE_FORMAT = (type = 'CSV' skip_header = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '"');
                    

CREATE OR REPLACE TABLE raw_hosts
                    (id integer,
                     name string,
                     is_superhost string,
                     created_at datetime,
                     updated_at datetime);
                    
COPY INTO raw_hosts (id, name, is_superhost, created_at, updated_at)
                   from 's3://dbtlearn/hosts.csv'
                    FILE_FORMAT = (type = 'CSV' skip_header = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '"');
```

this is a public bucket on a street `from 's3://dbtlearn/listings.csv'` from Airbnb and modified a little bit.

Refesh the page:

![](img/19.png)

And you ca see the news tables. Database and be in a schema called RAW

![](img/20.png)

**Setup instructions and Prerequisites**

* PYTHON VERSION : At the time (May 2023), dbt is compatible with Python 3.7, 3.8, 3.9, 3.10, and 3.11, but the supported Python version depends both on the dbt version and on the dbt-snowflake version you install. So make sure to install Python 3.11. DO NOT USE Python 3.12 as dbt doesn't support it.

* GIT : Git needs to be installed on your computer to avoid a (harmless) error message. 

* COPY-PASTING THE SNOWFLAKE PASSWORD : When you set up your dbt project, and it asks for your Snowflake password, type in the password instead of copy-pasting it.

* CREATE YOUR DBT FOLDER MANUALLY (DO THIS OTHERWISE DBT WILL FAIL TO CREATE A NEW PROJECT)

  * Windows: 
    * Make sure to execute mkdir %userprofile%\.dbt in a cmd window to ensure you can create a dbt project (you are instructed to do this in the dbt setup lecture). 
    * If you already have Python, pip, and virtualenv installed, feel free to create a folder for the course (I'm using Desktop/course), create a virtualenv called venv and skip the following two videos about Python setup and Virtualenv.   
  * Mac users: 
    * If you are on a Mac and you don't have a working Python 3.11 installation, we suggest that you install it through brew install `python@3.11 virtualenv`. We have added an optional video to cover the Mac Python installation process.
    * Make sure to execute `mkdir ~/.dbt` in a terminal now to ensure you can create a dbt project as the course progresses (you are instructed to do this in the dbt setup lecture).
  * Linux users:
    * If you use Linux, install a Python 3.11 virtualenv (like apt install python3.11-venv on Ubuntu) and follow the Mac instructions.
  * Using dbt Cloud
    * Currently, we can't support dbt Cloud-based setups. So feel free to give dbt Cloud a shot, but remember that we can only provide you with limited support. Any feedback about your dbt Cloud course experience is very welcome!

```sh
➜  DataEngineer_dbt_Bootcamp git:(main) ✗ python3 --version
Python 3.11.6
➜  DataEngineer_dbt_Bootcamp git:(main) ✗ python3 -m venv dbt_env
➜  DataEngineer_dbt_Bootcamp git:(main) ✗ source dbt_env/bin/activate
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ 
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ pip install dbt-snowflake==1.7.1
```

### dbt setup

First, you will need to create a DBT configuration folder. The idea is that you got to have a dot DB folder in your home folder.


You have the information here:


```sql
-- -- Create the `dbt` user and assign to role
-- CREATE USER IF NOT EXISTS dbt
--   PASSWORD='dbtPassword123'
--   LOGIN_NAME='dbt'
--   MUST_CHANGE_PASSWORD=FALSE
--   DEFAULT_WAREHOUSE='COMPUTE_WH'
--   DEFAULT_ROLE=TRANSFORM
--   DEFAULT_NAMESPACE='AIRBNB.RAW'
--   COMMENT='DBT user used for data transformation';
-- GRANT ROLE TRANSFORM to USER dbt;

-- -- Create our database and schemas
-- CREATE DATABASE IF NOT EXISTS AIRBNB;
-- CREATE SCHEMA IF NOT EXISTS AIRBNB.RAW;
```
`dbt_learn` is the name of my project.

```sh
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ mkdir ~/.dbt
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ dbt init dbt_learn
      17:19:41  Running with dbt=1.7.17
      17:19:41  
      Your new dbt project "dbt_learn" was created!

      For more information on how to configure the profiles.yml file,
      please consult the dbt documentation here:
        https://docs.getdbt.com/docs/configure-your-profile

      One more thing:
      Need help? Don't hesitate to reach out to us via GitHub issues or on Slack:
        https://community.getdbt.com/

      Happy modeling!

      17:19:41  Setting up your profile.
      Which database would you like to use?
      [1] snowflake
      (Don't see the one you want? https://docs.getdbt.com/docs/available-adapters)

      Enter a number: 1
      account (https://<this_value>.snowflakecomputing.com): borysxs-qp53113
      user (dev username): dbt
      [1] password
      [2] keypair
      [3] sso
      Desired authentication type option (enter a number): 1
      password (dev password): 
      role (dev role): transform
      warehouse (warehouse name): COMPUTE_WH
      database (default database that dbt will build objects in): AIRBNB
      schema (default schema that dbt will build objects in): DEV
      threads (1 or more) [1]: 
      17:28:22  Profile dbt_learn written to /Users/alex/.dbt/profiles.yml using target's profile_template.yml and your supplied values. Run 'dbt debug' to validate the connection.
```

`threads (1 or more) [1]:` This means that when you execute DB and there are multiple parallel transformations that DB can run, how many DB should use in parallel? It might matter for larger projects when you need to decide how much you want to overload your data wharehouse.

As you see here, it says we have now a DBT profiles YAML created and this stores `.dbt/profiles.yml`.

```sh
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) tree -L 1
.
├── README.md
├── dbt_env
├── dbt_learn
├── img
└── logs
```

`dbt debug` Makes a connection to your database, and it also checks some of the configuration files and it just, so let's execute DB to debug.

```sh
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) cd dbt_learn
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt debug
      17:34:25  Running with dbt=1.7.17
      17:34:25  dbt version: 1.7.17
      17:34:25  python version: 3.11.6
      17:34:25  python path: /Users/alex/Desktop/DataEngineer_dbt_Bootcamp/dbt_env/bin/python3.11
      17:34:25  os info: macOS-14.3.1-x86_64-i386-64bit
      17:34:26  Using profiles dir at /Users/alex/.dbt
      17:34:26  Using profiles.yml file at /Users/alex/.dbt/profiles.yml
      17:34:26  Using dbt_project.yml file at /Users/alex/Desktop/DataEngineer_dbt_Bootcamp/dbt_learn/dbt_project.yml
      17:34:26  adapter type: snowflake
      17:34:26  adapter version: 1.7.1
      17:34:26  Configuration:
      17:34:26    profiles.yml file [OK found and valid]
      17:34:26    dbt_project.yml file [OK found and valid]
      17:34:26  Required dependencies:
      17:34:26   - git [OK found]

      17:34:26  Connection:
      17:34:26    account: borysxs-qp53113
      17:34:26    user: dbt
      17:34:26    database: AIRBNB
      17:34:26    warehouse: COMPUTE_WH
      17:34:26    role: transform
      17:34:26    schema: DEV
      17:34:26    authenticator: None
      17:34:26    private_key_path: None
      17:34:26    token: None
      17:34:26    oauth_client_id: None
      17:34:26    query_tag: None
      17:34:26    client_session_keep_alive: False
      17:34:26    host: None
      17:34:26    port: None
      17:34:26    proxy_host: None
      17:34:26    proxy_port: None
      17:34:26    protocol: None
      17:34:26    connect_retries: 1
      17:34:26    connect_timeout: None
      17:34:26    retry_on_database_errors: False
      17:34:26    retry_all: False
      17:34:26    insecure_mode: False
      17:34:26    reuse_connections: None
      17:34:26  Registered adapter: snowflake=1.7.1
      17:34:28    Connection test: [OK connection ok]

      17:34:28  All checks passed!
```
And here you will see that we have several fathers and also five in your beautiful daughter, which is quite a DBT project.

```sh
(dbt_env) ➜  dbt_learn git:(main) tree -L 1   
.
├── README.md
├── analyses
├── dbt_project.yml
├── logs
├── macros
├── models
├── seeds
├── snapshots
└── tests
```

`dbt_project.yml` is our global configuration for this project. So these are standard project level configurations and here are our model level configuration.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat dbt_project.yml 

# Name your project! Project names should contain only lowercase characters
# and underscores. A good package name should reflect your organization's
# name or the intended use of these models
name: 'dbt_learn'
version: '1.0.0'

# This setting configures which "profile" dbt uses for this project.
profile: 'dbt_learn'

# These configurations specify where dbt should look for different types of files.
# The `model-paths` config, for example, states that models in this project can be
# found in the "models/" directory. You probably won't need to change these!
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:         # directories to be removed by `dbt clean`
  - "target"
  - "dbt_packages"


# Configuring models
# Full documentation: https://docs.getdbt.com/docs/configuring-models

# In this example config, we tell dbt to build all models in the example/
# directory as views. These settings can be overridden in the individual model
# files using the `{{ config(...) }}` macro.
models:
  dbt_learn:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
```

delete these lines

```sh
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
```

If you take a look at the model, you see we have some example in water set up here by default. So we like to ask you to delete the example for to just get in the folder itself.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ ls -la models
total 0
drwxr-xr-x   3 alex  staff   96 Jul  8 19:14 .
drwxr-xr-x  12 alex  staff  384 Jul  8 19:34 ..
drwxr-xr-x   5 alex  staff  160 Jul  8 19:14 example
```

```sh
my_new_project/
├── analysis/
├── seeds/
├── dbt_packages/
├── macros/
├── models/
│   ├── example/
│   └── README.md
├── snapshots/
├── tests/
├── .gitignore
├── dbt_project.yml
├── packages.yml
└── README.md
```

```
(dbt_env) ➜  dbt_learn git:(main) ✗ rm -r models/example
```

#### VSC extension : [vscode-dbt-power-user](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user)

![](img/21.png)

![](img/22.png)

![](img/23.png)

![](img/24.png)

When you are creating a new dbt project and you don't have a `packages.yml `file nor know what dependencies you might need, you can start with an empty packages.yml file. Then, as you develop your project and discover which additional packages might be useful, you can add those dependencies to the file.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat packages.yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.2.0
```

![](img/26.png)

```sh
(dbt_env) ➜  dbt_learn git:(main) tree -L 1                   
.
├── README.md
├── analyses
├── dbt_packages
├── dbt_project.yml
├── logs
├── macros
├── models
├── package-lock.yml
├── packages.yml
├── seeds
├── snapshots
├── target
└── tests
```

## Data Flow - Overview

So here is the data flow we are going to build. 

As you see in green, we have three input tables: `Costs, listings, and reviews`.   
* We will import these input tables and make minor modifications in our first layer, the `src (source)` layer.  
* We will then clean these tables and create our dimension tables `dim` and the `fct_reviews` fact table. 
* Additionally, we will use an external table and send data to Snowflake via dbt. 
* With the help of dbt, we will create a few so-called `mart_fullmoon_reviews` tables, which will be used by an executive dashboard. As we do this, we will also create a set of tests, which you can see here in the square.

![](img/33.png)



![](img/35.png)


And let's go and start building our first three mortars, SSD hosts, associate listings and SSD reviews.

INPUT DATA MODEL

![](img/27.png)

Three of these are directly connected to Airbnb. 
* First, the `listing`. 
* Then, the Airbnb `reviews`, which are linked to the `listings` through the `listing ID`.
* Additionally, there are the Airbnb `hosts`, who are also connected to the listings table via the `host ID`. 
* We also have an additional table, which we will upload, called `full_moon_dates`. With the help of this table, you will have the opportunity to examine how full moon phases affect Airbnb reviews.

Previously, we have created [these tables](#snowflake-data-import)

![](img/28.png)

raw listing

![](img/29.png)

raw host

![](img/30.png)

raw reviews

![](img/31.png)

### Models

Objectives:  
* Understand the data flow of our project
* Understand the concept of Models in dbt
* Create three basic models:
  * src_listings
  * src_reviews: guided exercises
  * src_hosts: individual lab

**Models Overview**


* Models are the basic building block of your business logic
* Materialized as tables, views, etc...
* They live in SQL files in the `models` folder
* Models can reference each other and use templates and macros
  
Models are the basic building blocks of your business logic and the foundational elements of a dbt project.  
You can think of models as SQL queries that materialize as tables or views, but there is much more to them.  
For now, what you need to know about models is that they are stored as SQL files in the models folder. 

They are not just simple SQL SELECT statements; they can include additional features. For example, a model can reference other models, allowing dbt to understand the semantic dependencies between them. You can also use different scripts and macros within your models. Now, let's see how they work in action.

#### Common Table Expression (CTE)

CTEs help us write readable and maintainable SQL code. By definition, they are temporary, named result sets that exist only for the duration of a single query. CTEs are great because the result remains in memory during the execution of the query (e.g., SELECT, INSERT, UPDATE, DELETE, or MERGE). The syntax of a CTE looks something like this:

```SQL
# Syntax
WITH name_of_the_result_set (column_names) AS (
    cte_query
)
<reference_the_CTE>
```

The column names are optional and used to set up aliases for the column names that come out of the CTE. A CTE is a SELECT statement, and in reality, it is a temporary result set that can be referenced within the FROM clause of a query, just like any other table. The reference to the CTE is where we execute and use our common table expression.

Let's say we extracted raw data from the source systems via Airbnb. The data is 100% uncleaned, and we want to perform transformations on it. In step one, we create a CTE named `raw_listings`. Then in step two, we have an inner query that selects all columns from the source `listings` table. Finally, in step three, which is an outer query, we reference the CTE `raw_listings`.

In this outer query, we select specific columns from the source, performing simple transformations such as renaming the `id` column to `listing_id` to make it more descriptive.

SQL
Copy code

```SQL
# exemple
-- STEP 1
WITH raw_listings AS (

    -- STEP 2
    SELECT * FROM [source].[listings]
)

-- STEP 3
SELECT
    id AS listing_id,
    listing_url,
    name AS listing_name,
    room_type,
    minimum_nights,
    host_id,
    price AS price_str,
    created_at,
    updated_at
FROM raw_listings;
```

Although a CTE has similar functionality to a view, CTEs are not stored in metadata. We prefer CTEs because they are extremely readable, easy to maintain, and make complex queries more understandable. Furthermore, a query can be divided into separate, simple, logical building blocks, which can then be used to build more complex queries.

Lastly, CTEs can also be defined in functions, stored procedures, triggers, or even views. You will use CTEs many times throughout the course, so you will see plenty of examples soon.

#### Creating our first model: Airbnb listings

![](img/36.png)

As you can see in our raw layer, we have three input tables: `raw_listings`, `raw_hosts`, and `raw_reviews`.  

Now, it's time to create our first staging layer. In this layer, we will prefix every staging table or view with the `src` tag. Our goal here is to build three models: 
* one for listings, 
* one for hosts, 
* and one for reviews.  

These models will be views built on top of the raw data in the `raw_listings`, `raw_hosts`, and `raw_reviews` tables.  
We will make some minor changes to these tables, such as renaming columns, as a first step in cleansing our data.

---
Creating a new model in the `models/src/` folder called `src_rlisting.sql`:


So let's implement our first select statement where we are changing these column names. And it's a standard practice in the analytics community to use CTE common table expressions For all of our input sources. I will create a comfortable expression which points to the role listing stable.

![](img/38.png)

So now it's time to integrate Discovery into DBT. And let's create our first one.

Similar live here in the models folder and you can organize your models into subfolders or you can just keep them at the top level. It really depends on how you like to organize your structure. I would suggest you to organize it into subfolders layer by layer. So let's create our first layer. 

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ mkdir -p models/src
(dbt_env) ➜  dbt_learn git:(main) ✗ touch models/src/src_listings.sql     # Create src_listings.sql
```

```sh
├── macros
├── models
│   └── src
│       └── src_listings.sql
```

name column change  
* `name AS listing_name`,
* `price AS price_str`,

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ nano models/src/src_listings.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/src/src_listings.sql 

  WITH raw_listings AS (
      SELECT * FROM AIRBNB.RAW.RAW_LISTINGS
  )
  SELECT
      id AS listing_id,
      name AS listing_name,
      listing_url,
      room_type,
      minimum_nights,
      host_id,
      price AS price_str,
      created_at,
      updated_at
  FROM
      raw_listings
```

So now Dbt knows that I want to have a view created called src_listings. And this is the definition of the view. So this is my first term placeholder and we will discuss later how you can manage this to be a table. But by default, all our models are going to be views. Save it´s and now let's execute DVT.

dbt run  

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run              
  18:35:45  Running with dbt=1.7.17
  18:35:45  Registered adapter: snowflake=1.7.1
  18:35:45  Found 1 model, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  18:35:45  
  18:35:48  Concurrency: 1 threads (target='dev')
  18:35:48  
  18:35:48  1 of 1 START sql view model DEV.src_listings ................................... [RUN]
  18:35:49  1 of 1 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.57s]
  18:35:49  
  18:35:49  Finished running 1 view model in 0 hours 0 minutes and 4.18 seconds (4.18s).
  18:35:49  
  18:35:49  Completed successfully
  18:35:49  
  18:35:49  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

Let's take a look in Snowflake. Refresh and look the view

![](img/39.png)


---
Creating a new model in the `models/src/` folder called `src_reviews.sql`:
* Use a CTE to reference the AIRBNB.RAW.RAW_REVIEWS table
* SELECT every column and every record, and rename the following columns:
  * date to review_date
  * comments to review_text
  * sentiment to review_sentiment
* Execute `dbt run` and verify that your model has been created

![](img/40.png)

```sh
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ touch dbt_learn/models/src/src_reviews.sql
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ nano dbt_learn/models/src/src_reviews.sql 
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ cat dbt_learn/models/src/src_reviews.sql

  WITH raw_reviews AS (
      SELECT * FROM AIRBNB.RAW.RAW_REVIEWS
  )
  SELECT
      listing_id,
      date AS review_date,
      reviewer_name,
      comments AS review_text,
      sentiment AS review_sentiment
  FROM
      raw_reviews
```

dbt run  

```sh
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ cd dbt_learn 
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run     
  04:43:21  Running with dbt=1.7.17
  04:43:21  Registered adapter: snowflake=1.7.1
  04:43:21  Found 2 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  04:43:21  
  04:43:24  Concurrency: 1 threads (target='dev')
  04:43:24  
  04:43:24  1 of 2 START sql view model DEV.src_listings ................................... [RUN]
  04:43:25  1 of 2 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.32s]
  04:43:25  2 of 2 START sql view model DEV.src_reviews .................................... [RUN]
  04:43:26  2 of 2 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.27s]
  04:43:26  
  04:43:26  Finished running 2 view models in 0 hours 0 minutes and 5.23 seconds (5.23s).
  04:43:26  
  04:43:26  Completed successfully
  04:43:26  
  04:43:26  Done. PASS=2 WARN=0 ERROR=0 SKIP=0 TOTAL=2
```

![](img/41.png)

---
Creating a new model in the `models/src/` folder called `src_hosts.sql`:
* Use a CTE to reference the AIRBNB.RAW.RAW_HOSTS table
* SELECT every column and every record, and rename the following columns:
    * id AS host_id,
    * NAME AS host_name,
* Execute `dbt run` and verify that your model has been created

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ touch models/src/src_hosts.sql            
(dbt_env) ➜  dbt_learn git:(main) ✗ nano models/src/src_hosts.sql 
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/src/src_hosts.sql
  WITH raw_hosts AS (
      SELECT * FROM AIRBNB.RAW.RAW_HOSTS
  )
  SELECT
      id AS host_id,
      NAME AS host_name,
      is_superhost,
      created_at,
      updated_at
  FROM
      raw_hosts
```

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
  05:13:40  Running with dbt=1.7.17
  05:13:40  Registered adapter: snowflake=1.7.1
  05:13:41  Found 3 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  05:13:41  
  05:13:43  Concurrency: 1 threads (target='dev')
  05:13:43  
  05:13:43  1 of 3 START sql view model DEV.src_hosts ...................................... [RUN]
  05:13:44  1 of 3 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.37s]
  05:13:44  2 of 3 START sql view model DEV.src_listings ................................... [RUN]
  05:13:46  2 of 3 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.31s]
  05:13:46  3 of 3 START sql view model DEV.src_reviews .................................... [RUN]
  05:13:47  3 of 3 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.26s]
  05:13:47  
  05:13:47  Finished running 3 view models in 0 hours 0 minutes and 6.49 seconds (6.49s).
  05:13:47  
  05:13:47  Completed successfully
  05:13:47  
  05:13:47  Done. PASS=3 WARN=0 ERROR=0 SKIP=0 TOTAL=3
```

**Created our first model: Airbnb listings**

![](img/36.png)

### Materializations

* Understand how models can be connected
* Understand the four built-in materializations
* Understand how materializations can be configured on the file and project level
* Use dbt run with extra parameters
  
Materializations are different race, how your models can be stored and managed in the data warehouse. There are 4th materializations

![](/img/43.png)

* A view is the default materialization in dbt. When you select the "view" materialization, dbt will create a database view for your model. Views are virtual tables that display the results of a stored query. They are lightweight because they don’t store data themselves but instead fetch data dynamically whenever queried.
  With a `view`, you want to use it when you need a lightweight representation of your data and don’t need to recreate a table at every execution. However, avoid using views if you need to read from the same `view` multiple times in quick succession, as each access will require the underlying query to be executed, potentially impacting performance.
* Choosing "table" as your materialization will make dbt create a physical table in your database. Every time you run dbt run, this table will be recreated from scratch. This is useful for models that you query frequently and where performance is important, but it is not ideal for models that are updated incrementally or are only used once.
  For efficient repeated access, consider using the `table` materialization. The downside is that it needs to be recreated every time you run your pipeline, which can take extra time. However, once created, the data is readily available, making subsequent reads fast.
* The "incremental" materialization is designed for scenarios where you need to add new rows to a table without recreating it from scratch every time. This is particularly useful for event data or other types of fact tables where data is continuously appended. However, it is not suitable for updating existing records.
  For data that is `incrementally` updated, such as event data (e.g., orders in an e-commerce system or reviews), the incremental materialization is ideal. This method allows you to append new data without recreating the entire table, optimizing performance and storage.
* An "ephemeral" model in dbt is not materialized into a physical table or view. Instead, it exists only within the context of a dbt run and is used as a Common Table Expression (CTE) in the downstream models. This means that the data is never stored in the database but is used to streamline complex queries within dbt. This is useful for intermediate calculations or transformations that don’t need to be stored permanently.
  Finally, if you need an intermediate step between models without publishing it to the data warehouse, the `ephemeral` materialization is useful. Ephemeral models exist only within the context of a dbt run as Common Table Expressions (CTEs) and do not create physical tables or views in your database, making them ideal for temporary calculations and transformations.

| Materialization | Use it when...                                               | Don’t use it when...                                             | Explanation                                                                                         |
|-----------------|--------------------------------------------------------------|------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| **View**        | You want a lightweight representation and don’t reuse data often | You need to read from the same model several times                | A view creates a virtual table that fetches data dynamically whenever queried.                      |
| **Table**       | You read from this model repeatedly                           | Building single-use models or your model is populated incrementally | A table creates a physical table that is recreated from scratch every time `dbt run` is executed.   |
| **Incremental** | Fact tables or appending to tables                           | You want to update historical records                             | An incremental table adds new rows without recreating the entire table, ideal for event/fact data.  |
| **Ephemeral**   | You need an alias to your data                               | You need to read from the same model several times                | An ephemeral model exists only during a dbt run as a CTE, not materialized in the database.         |



So we will see an example to all of those in the upcoming lessons.

#### Model Dependencies and dbt's ref tag

We are going to build out a new layer, the core layer, core layer comes with a bunch of chambers. From `src_listing` we are going to create `dim_lisitng_cleansed`, etc

![](img/47.png)

And you're going to create our final dimension table by joining these two tables together.

![](img/48.png)

you will see how we can define dependencies between models and how we can create different materializations and apply them in snowflake.

IN snowflakw look you and make sure that you have de views `SRC_HOST`, `SRC_LISTINGS` AND `SRC_REVIEWS`.

---

For `dimension` tables we are to create a new folder in models 

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ mkdir -p models/dim                       
(dbt_env) ➜  dbt_learn git:(main) ✗ touch models/dim/dim_listings_cleansed.sql
```

Here, I want to build on top of the SLC listings there and the additional dim_listings_clear . 

I have created this file above VSCode app with de extension dbt and jinja configuration.

```SQL
WITH src_liting AS (
    SELECT * FROM {{ ref('src_listings') }}
)

SELECT ...
```

`ref('src_listing')` This is a bdt specific template tag in SQL, which does dbt to substitute this template with the name sql_listing.sql, Technically speaking, it is a [jinja template](https://palletsprojects.com/p/jinja/) tag. The main idea behind Jinjr is that you can define these templates where I have us and also some control structures like loops and conditional statements and ginger passes for you, DVT heavily relies on jinjar.

If you look at the preview of the SRC_LISTINGS Snowflake table, you will notice that several instances in the MINIMUM_NIGHTS column contain zeros. And this is a problem i the data, thre is the minimun of nigths is 1 night that needs to bo booked in order to reserve this Airbnb. And also the price now gold price SDR. It is in a string format, So let's just pass this into our numeric form.

![](/img/45.png)

I have created this file above VSCode app with de extension dbt and jinja configuration.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/dim/dim_listings_cleansed.sql 

  WITH src_liting AS (
      SELECT * FROM {{ ref('src_listings') }}
  )
  SELECT
    listing_id,
    listing_name,
    room_type,
    CASE
      WHEN minimum_nights = 0 THEN 1
      ELSE minimum_nights
    END AS minimum_nights,
    host_id,
    REPLACE(
      price_str,
      '$'
    ) :: NUMBER(
      10,
      2
    ) AS price,
    created_at,
    updated_at
  FROM
    src_listings
```

dbt run

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
  07:41:12  Running with dbt=1.7.17
  07:41:12  Registered adapter: snowflake=1.7.1
  07:41:13  Found 4 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  07:41:13  
  07:41:18  Concurrency: 1 threads (target='dev')
  07:41:18  
  07:41:18  1 of 4 START sql view model DEV.src_hosts ...................................... [RUN]
  07:41:20  1 of 4 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.37s]
  07:41:20  2 of 4 START sql view model DEV.src_listings ................................... [RUN]
  07:41:21  2 of 4 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.31s]
  07:41:21  3 of 4 START sql view model DEV.src_reviews .................................... [RUN]
  07:41:22  3 of 4 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.22s]
  07:41:22  4 of 4 START sql view model DEV.dim_listings_cleansed .......................... [RUN]
  07:41:24  4 of 4 OK created sql view model DEV.dim_listings_cleansed ..................... [SUCCESS 1 in 1.30s]
  07:41:24  
  07:41:24  Finished running 4 view models in 0 hours 0 minutes and 11.11 seconds (11.11s).
  07:41:24  
  07:41:24  Completed successfully
  07:41:24  
  07:41:24  Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

![](/img/49.png)

![](/img/46.png)

---

Create a new model in the `models/dim/` folder called `dim_hosts_cleansed.sql`.
* Use a CTE to reference the `src_hosts` model
* SELECT every column and every record, and add a cleansing step to
host_name:
  * If host_name is not null, keep the original value
  * If host_name is null, replace it with the value ‘Anonymous’
  * Use the NVL(column_name, default_null_value) function
* Execute `dbt run` and verify that your model has been created

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/dim/dim_hosts_cleansed.sql
-- models/dim/dim_hosts_cleansed.sql

WITH src_hosts AS (
    SELECT * FROM {{ ref('src_hosts') }}
)
SELECT 
    host_id,
    NVL(host_name, 'Anonymous') AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    src_hosts
```

Explanation:
* CTE (Common Table Expression): defined `src_hosts` to reference the model.
* Cleansing Step: The `host_name` column is cleansed by using the NVL function to replace NULL values with 'Anonymous'.
* Columns Selection: Every column from the `src_hosts` table is selected with the host_name column being modified for cleansing.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
  10:47:32  Running with dbt=1.7.17
  10:47:32  Registered adapter: snowflake=1.7.1
  10:47:32  Found 5 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  10:47:32  
  10:47:36  Concurrency: 1 threads (target='dev')
  10:47:36  
  10:47:36  1 of 5 START sql view model DEV.src_hosts ...................................... [RUN]
  10:47:38  1 of 5 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.39s]
  10:47:38  2 of 5 START sql view model DEV.src_listings ................................... [RUN]
  10:47:39  2 of 5 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.36s]
  10:47:39  3 of 5 START sql view model DEV.src_reviews .................................... [RUN]
  10:47:40  3 of 5 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.23s]
  10:47:40  4 of 5 START sql view model DEV.dim_hosts_cleansed ............................. [RUN]
  10:47:42  4 of 5 OK created sql view model DEV.dim_hosts_cleansed ........................ [SUCCESS 1 in 1.29s]
  10:47:42  5 of 5 START sql view model DEV.dim_listings_cleansed .......................... [RUN]
  10:47:43  5 of 5 OK created sql view model DEV.dim_listings_cleansed ..................... [SUCCESS 1 in 1.34s]
  10:47:43  
  10:47:43  Finished running 5 view models in 0 hours 0 minutes and 10.55 seconds (10.55s).
  10:47:43  
  10:47:43  Completed successfully
  10:47:43  
  10:47:43  Done. PASS=5 WARN=0 ERROR=0 SKIP=0 TOTAL=5
```

---

#### Table type materialization & Project-level Materialization config


So far, the only materialization we used is the view materialization, so the default. So we have now these five views in Snowflake.  So we have now these five views in Snowflake 
* `DIM_HOSTS_CLEANSED`, 
* `DIM_LISTINGS_CLEANSED`, 
* `SRC_HOSTS`, 
* `SRC_LISTINGS`, 
* `SRC_REVIEWS`

```sh
├── models
│   ├── dim
│   │   ├── dim_hosts_cleansed.sql
│   │   └── dim_listings_cleansed.sql
│   └── src
│       ├── src_hosts.sql
│       ├── src_listings.sql
│       └── src_reviews.sql
```

But first of all, let's be explicit about our default malitarization. So what I'd like to open how the `dbt_project.yml` and come to the end.  

The `dbt_project.yml` is the file where you can set subfolder and global configurations. I want to specify that my militarization is for you. I can add the new line and just saying `+materialized: view`.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ nano dbt_project.yml 

# this lines
models:
  dbt_learn:
        +materialized: view # add this line
```

* `dbt_learn:` This specifies a sub-section within the models configuration. The dbt_learn key corresponds to a specific directory or group of models within your project. In this case, it refers to models located in the dbt_learn directory.
* `+materialized: view` : This line is an added configuration setting for the models in the dbt_learn directory. +materialized is a dbt directive that specifies the materialization strategy for these models. 
* `view` means that dbt will create a database `view` **for each model in the dbt_learn directory**. Views are virtual tables that are defined by a query but do not store data physically.

In this case, you would want the sources `src_hosts`, `src_listings`, and `src_reviews` to be materialized as views because they involve very transformations and probably won't be accessed directly very often. 

However, for `dim_hosts_cleansed` and `dim_listings_cleanset`, which are already cleansed and stable, they will be accessed quite often. Therefore, it makes sense for these to be materialized differently, possibly as tables, to optimize performance for frequent queries.

So I want to make sure that these configurations align with our performance estimates. So will come now and define it as:

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ nano dbt_project.yml 

# this lines
models:
  dbt_learn:
        +materialized: view 
        dim: # add this line
          +materialized: table # add this line
```

By adding these lines, you are differentiating the materialization between different types of models in your project:

* `Views` for **Lightweight Models (src)**: The `src_hosts`, `src_listings`, and `src_reviews` models are materialized as views because they involve very lightweight transformations and probably won't be accessed directly very often.

* `Tables` for **Cleansed Models (dim)**: The `dim_hosts_cleansed` and `dim_listings_cleansed` models, which are already cleansed and stable, will be materialized as tables because they will be accessed frequently. Materializing them as tables optimizes the performance of frequent queries.
  * `dim` : Specifies another subsection within dbt_learn. The key dim corresponds to specific models within the dim subdirectory in dbt_learn.
  * `+materialized: table` : This line is an added configuration for the models in the dim subdirectory within the dbt_learn directory.
table means that dbt will create a physical table for each model in the dim subdirectory. Tables store data physically, which generally improves the performance of frequent queries.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
  15:42:07  Running with dbt=1.7.17
  15:42:08  Registered adapter: snowflake=1.7.1
  15:42:08  Found 5 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  15:42:08  
  15:42:15  Concurrency: 1 threads (target='dev')
  15:42:15  
  15:42:15  1 of 5 START sql view model DEV.src_hosts ...................................... [RUN]
  15:42:16  1 of 5 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.52s]
  15:42:16  2 of 5 START sql view model DEV.src_listings ................................... [RUN]
  15:42:18  2 of 5 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.52s]
  15:42:18  3 of 5 START sql view model DEV.src_reviews .................................... [RUN]
  15:42:19  3 of 5 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.28s]
  15:42:19  4 of 5 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
  15:42:22  4 of 5 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 2.92s]
  15:42:22  5 of 5 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
  15:42:24  5 of 5 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 2.37s]
  15:42:24  
  15:42:24  Finished running 3 view models, 2 table models in 0 hours 0 minutes and 15.78 seconds (15.78s).
  15:42:24  
  15:42:24  Completed successfully
  15:42:24  
  15:42:24  Done. PASS=5 WARN=0 ERROR=0 SKIP=0 TOTAL=5
```
and look in the snowflake:

![](/img/50.png)

#### Incremental materialization

> In the context of dbt (Data Build Tool), "incremental" refers to a type of materialization that allows updating only a part of the table instead of rebuilding the entire table from scratch every time the model is run. This approach is especially useful for large volumes of data, as it reduces processing time and computational load.

Here we have associate **reviews**, which you are already familiar with, which has a `listing_ID`, `review_dates`, `reviewe_name`, `reviewe_text` and also the `review_sentiment`.

![](/img/60.png)

Now we are performing our two steps in the following order:
1. Cleansing: We ensure that only reviews containing actual text are included in our effective table.
2. Incremental Updates: We make sure that these reviews are updated incrementally rather than being recreated during each dbt run.


```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ mkdir -p models/fct
(dbt_env) ➜  dbt_learn git:(main) ✗ touch models/fct/fct_reviews.sql
```

So first, let's create a standard table **without any increment**.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/fct/fct_reviews.sql

WITH src_reviews AS (
    SELECT * FROM {{ ref("src_reviews") }}
)
SELECT * FROM src_reviews
WHERE review_text is not null%  
```
Now, we want to change this **to use incremental materialization**.  
To do this, we will use `Jinja` syntax in dbt to configure our model for incremental updates.  
Here is the configuration:

```sh
{{
    config(
    materialized = 'incremental',
    on_schema_change='fail'
    )
}}
WITH src_reviews AS (
    SELECT * FROM {{ ref("src_reviews") }}
)
SELECT * FROM src_reviews
WHERE review_text is not null
```

Configuration block:
* `materialized = 'incremental'`: This setting configures the model to use incremental materialization. In dbt, incremental models only process and add new or updated data since the last run, rather than rebuilding the entire table. This is useful for large datasets where full refreshes are time-consuming and resource-intensive.
* `on_schema_change='fail'`: This setting specifies the action dbt should take if there is a change in the schema of the source table. Setting this to 'fail' means that the incremental model will fail if there is a schema change detected in the source data. This is a safety measure to prevent unexpected issues caused by schema changes.

Up until now, all views and tables were recreated every time we executed `dbt run`. However, with incremental materialization, we maintain a stable table (`fct_reviews`) that is updated incrementally. 

If there is a schema change upstream, we need to be aware of it and react accordingly.  
By setting `on_schema_change` to 'fail', we ensure that any unexpected schema changes will cause the model to fail, prompting us to address the issue before proceeding.

But I also need to tell DBT how to increment. I need to tell DBT, what are the new records right? How it knows from record that it's new are not.  And here I can go and simply create a jinjar if statements for this. 

```SQL
{% if is_incremental() %}
  AND review_date > (select max(review_date) from {{ this }})
{% endif %}
```
* This section uses Jinja templating to add conditional logic to the query. 
* The `is_incremental()` function checks if the model is running in incremental mode. 
* If the model is running incrementally, the condition 
  * `AND review_date > (select max(review_date) from {{ this }})` is added to the 
  * `WHERE` clause `review_text` 
* This ensures that only new records with a review_date greater than the maximum review_date already present in the target table (represented by {{ this }}) are included in the incremental run.

> Now, notice for a second how much freedom this leaves you because. Here, if you want to have some more sophisticated logic, like working on an updated feared or anything doing with IDs, whatever. You're free to express it here in SQL.

From **scr_reviews**, which has a `listing_ID`, `review_dates`, `reviewe_name`, `reviewe_text` and also the `review_sentiment`.

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/fct/fct_reviews.sql
  {{
      config(
      materialized = 'incremental',
      on_schema_change='fail'
      )
  }}
  WITH src_reviews AS (
      SELECT * FROM {{ ref("src_reviews") }}
  )
  SELECT * FROM src_reviews
  WHERE review_text is not null
  {% if is_incremental() %}
    AND review_date > (select max(review_date) from {{ this }})
  {% endif %}
```

When the model is configured as incremental, the goal is to add only the new data that hasn’t been processed previously. This is useful for saving time and resources by avoiding the processing of old data that hasn't changed. The clause `AND review_date > (select max(review_date) from {{ this }})` ensures that only the data more recent than the data already present in the target table is selected. Here’s the logic:

* `{{ this }}` refers to the table materialized previously by dbt.
* `(select max(review_date) from {{ this }})` fetches the date of the latest review that has already been processed.
* `AND review_date > ...` ensures that only the more recent reviews are selected, excluding those already in the target table.

Non-Incremental (Full Refresh) or in a full refresh mode, every time the model runs, all data is selected, and the target table is rebuilt from scratch. There is no optimization based on dates or other incremental criteria. 

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
16:27:01  Running with dbt=1.7.17
16:27:02  Registered adapter: snowflake=1.7.1
16:27:02  Found 6 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
16:27:02  
16:27:05  Concurrency: 1 threads (target='dev')
16:27:05  
16:27:05  1 of 6 START sql view model DEV.src_hosts ...................................... [RUN]
16:27:06  1 of 6 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.57s]
16:27:06  2 of 6 START sql view model DEV.src_listings ................................... [RUN]
16:27:08  2 of 6 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.42s]
16:27:08  3 of 6 START sql view model DEV.src_reviews .................................... [RUN]
16:27:09  3 of 6 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.41s]
16:27:09  4 of 6 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
16:27:12  4 of 6 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 2.65s]
16:27:12  5 of 6 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
16:27:14  5 of 6 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 2.12s]
16:27:14  6 of 6 START sql incremental model DEV.fct_reviews ............................. [RUN]
16:27:19  6 of 6 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 1 in 5.60s]
16:27:19  
16:27:19  Finished running 3 view models, 2 table models, 1 incremental model in 0 hours 0 minutes and 17.56 seconds (17.56s).
16:27:19  
16:27:19  Completed successfully
16:27:19  
16:27:19  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```


![](/img/52.png)


Let's create an incremental load now. For an incremental load, we need some incremental data, right? First of all, let's take a look at the reviews for listing ID 3176.

![](/img/53.png)


**Practical Example**

Imagine you have a reviews table (src_reviews) with millions of records, and only a few new reviews are added each day. With an incremental strategy, you process only those new reviews, which is much faster than reprocessing all millions of records each time.

Let's execute a command to add new reviews.

```SQL
INSERT INTO AIRBNB.RAW.RAW_REVIEWS VALUES (3176, CURRENT_TIMESTAMP(),
'Zoltan','excallent stay!', 'positive');
```

This INSERT command adds a new review to the RAW_REVIEWS table in the RAW schema of the AIRBNB database. It includes the listing ID 3176, the current timestamp as the review date, "Zoltan" as the reviewer's name, "Excellent stay!" as the review text, and "positive" as the sentiment.

![](/img/54.png)

And now with dbt run, we pick up and recreate the first reviews and and the two dimensional tables and execute an incremental load on the six model, the fact reviews.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
    16:39:49  Running with dbt=1.7.17
    16:39:50  Registered adapter: snowflake=1.7.1
    16:39:50  Found 6 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
    16:39:50  
    16:39:53  Concurrency: 1 threads (target='dev')
    16:39:53  
    16:39:53  1 of 6 START sql view model DEV.src_hosts ...................................... [RUN]
    16:39:54  1 of 6 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.43s]
    16:39:54  2 of 6 START sql view model DEV.src_listings ................................... [RUN]
    16:39:55  2 of 6 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.40s]
    16:39:55  3 of 6 START sql view model DEV.src_reviews .................................... [RUN]
    16:39:57  3 of 6 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.21s]
    16:39:57  4 of 6 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
    16:39:58  4 of 6 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 1.83s]
    16:39:58  5 of 6 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
    16:40:01  5 of 6 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 2.20s]
    16:40:01  6 of 6 START sql incremental model DEV.fct_reviews ............................. [RUN]
    16:40:05  6 of 6 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 1 in 4.01s]
    16:40:05  
    16:40:05  Finished running 3 view models, 2 table models, 1 incremental model in 0 hours 0 minutes and 14.74 seconds (14.74s).
    16:40:05  
    16:40:05  Completed successfully
    16:40:05  
    16:40:05  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```

OK, so it says that it's incremental the one motor.

```SQL
SELECT * FROM AIRBNB.DEV.FCT_REVIEWS WHERE listing_id=3176;
```

The incremental configuration `(materialized = 'incremental')` in dbt is useful for saving time and resources by processing only the new data that hasn’t been processed previously. The clause `AND review_date > (select max(review_date) from {{ this }})` is crucial in this context to ensure only new records are selected and processed.

![](/img/55.png)

Now, just one more trick before we go to our next session: what happens if you want to rebuild the entire table? You can do this by running the command `dbt run --full-refresh`.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run --full-refresh
  16:49:59  Running with dbt=1.7.17
  16:50:00  Registered adapter: snowflake=1.7.1
  16:50:00  Found 6 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  16:50:00  
  16:50:03  Concurrency: 1 threads (target='dev')
  16:50:03  
  16:50:03  1 of 6 START sql view model DEV.src_hosts ...................................... [RUN]
  16:50:04  1 of 6 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.51s]
  16:50:04  2 of 6 START sql view model DEV.src_listings ................................... [RUN]
  16:50:06  2 of 6 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.38s]
  16:50:06  3 of 6 START sql view model DEV.src_reviews .................................... [RUN]
  16:50:07  3 of 6 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.40s]
  16:50:07  4 of 6 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
  16:50:09  4 of 6 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 2.17s]
  16:50:09  5 of 6 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
  16:50:11  5 of 6 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 2.05s]
  16:50:11  6 of 6 START sql incremental model DEV.fct_reviews ............................. [RUN]
  16:50:16  6 of 6 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 1 in 5.10s]
  16:50:16  
  16:50:16  Finished running 3 view models, 2 table models, 1 incremental model in 0 hours 0 minutes and 16.42 seconds (16.42s).
  16:50:16  
  16:50:16  Completed successfully
  16:50:16  
  16:50:16  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```

Now Every incremental table has been rebuilt.

Now, I won't see any change here, of course, because this will bring me to the same state. However, if you ever change the schema of a source file or table, performing a full refresh will recreate the incremental or table models from scratch. This ensures that all schema changes are properly reflected in your models.


#### Ephemeral materialization

> In the context of dbt (Data Build Tool), "ephemeral" materialization refers to a type of materialization where the model is not stored as a table or view in the database, but is used only as a temporary expression within the dbt compilation process. Ephemeral models exist only during the execution of a dbt operation and do not persist in the database after the operation is complete.
>


The type of materialization for all of the tables we've created so far is shown in the diagram. We still need to create the `dim_listings_with_hosts`, which will be our final dimension table, so we will do that now.

![](img/48.png)

If you think about it, as an Airbnb analytics engineer, once we are done with processing, we end up with two main tables: 
* `dim_listings_with_hosts` and
* `fct_reviews`
  
These tables combine all the necessary data, such as 
* `dim_listings_with_hosts` -> `listings` joined with `hosts information` and 
* `fct_reviews` -> `review details`.

Since these tables are our final, stable tables that we frequently access for analytics, we can keep them stable by materializing them as tables or views. This means, for example, if we have 

* `dim_listings_cleansed` and `dim_hosts_cleansed` materialized as **views**, 

we don't need to create additional tables out of them because we will only read from these views.

![](img/56.png)

> By using **views** for `dim_listings_cleansed` and `dim_hosts_cleansed`, we can simplify our data processing pipeline and ensure that we have `up-to-date` data without the need for redundant table creation.


* `Ephemeral Materialization`: This refers to the practice of using temporary tables or views that do not persistently store data but are instead generated dynamically when needed.
* `Stable Tables`: The fct_reviews and dim_listings_with_hosts are considered stable because they combine all necessary data and are accessed frequently for analytics.
* `Using Views`: By materializing dim_listings_cleansed and dim_hosts_cleansed as views, we avoid creating unnecessary tables and keep our data processing pipeline efficient.
  

We still need to create the dimension table `dim_listings_with_hosts`, which will be our final dimension table. 

So, we will do that. If you think about it from the perspective of an Airbnb analytics engineer, after we are done with the cleansed listings and hosts, we will have two main tables here:

1. `fct_reviews`
2. `dim_listings_with_hosts`

These two tables will be our final tables in the core layer, which we will use repeatedly for analytics. Since 
* `dim_listings_cleansed` and 
* `dim_hosts_cleansed`

are intermediate views needed only for reading and processing, there is no need to convert them into permanent tables. 

> These views are used only during the creation of our final table `dim_listings_with_hosts`.

In summary, we will keep `dim_listings_with_hosts` and `fct_reviews` as our final tables and we don't need to create additional tables for `dim_listings_cleansed` and `dim_hosts_cleansed`. These can remain as views that get converted into CTEs (Common Table Expressions) during integration into the final tables.

So, this is what we will do: we will create the final table `dim_listings_with_hosts`.


```sh
(dbt_env) ➜  dbt_learn git:(main) touch models/dim/dim_listings_w_hosts.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ nano models/dim/dim_listings_w_hosts.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/dim/dim_listings_w_hosts.sql
  WITH
  l AS (
      SELECT
          *
      FROM
          {{ ref('dim_listings_cleansed') }}
  ),
  h AS (
      SELECT * 
      FROM {{ ref('dim_hosts_cleansed') }}
  )

  SELECT 
      l.listing_id,
      l.listing_name,
      l.room_type,
      l.minimum_nights,
      l.price,
      l.host_id,
      h.host_name,
      h.is_superhost as host_is_superhost,
      l.created_at,
      GREATEST(l.updated_at, h.updated_at) as updated_at
  FROM l
  LEFT JOIN h ON (h.host_id = l.host_id)
```

This script creates a CTE (Common Table Expression) for our listings and hosts.
* We reference the cleansed listings and hosts tables (`dim_listings_cleansed` and `dim_hosts_cleansed`) and read every column from these two tables.
* We also rename the column `is_superhost` to `host_is_superhost`.
* For the `updated_at` field, we ensure we keep the most recent update from either the listing or the host.

This is a simple and effective way to combine the listings and hosts into our final dimension table `dim_listings_with_hosts`.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
  17:08:06  Running with dbt=1.7.17
  17:08:06  Registered adapter: snowflake=1.7.1
  17:08:06  Found 7 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  17:08:06  
  17:08:17  Concurrency: 1 threads (target='dev')
  17:08:17  
  17:08:17  1 of 7 START sql view model DEV.src_hosts ...................................... [RUN]
  17:08:18  1 of 7 OK created sql view model DEV.src_hosts ................................. [SUCCESS 1 in 1.77s]
  17:08:18  2 of 7 START sql view model DEV.src_listings ................................... [RUN]
  17:08:20  2 of 7 OK created sql view model DEV.src_listings .............................. [SUCCESS 1 in 1.40s]
  17:08:20  3 of 7 START sql view model DEV.src_reviews .................................... [RUN]
  17:08:21  3 of 7 OK created sql view model DEV.src_reviews ............................... [SUCCESS 1 in 1.63s]
  17:08:21  4 of 7 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
  17:08:24  4 of 7 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 2.97s]
  17:08:24  5 of 7 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
  17:08:27  5 of 7 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 2.39s]
  17:08:27  6 of 7 START sql incremental model DEV.fct_reviews ............................. [RUN]
  17:08:31  6 of 7 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 0 in 4.11s]
  17:08:31  7 of 7 START sql table model DEV.dim_listings_w_hosts .......................... [RUN]
  17:08:33  7 of 7 OK created sql table model DEV.dim_listings_w_hosts ..................... [SUCCESS 1 in 1.98s]
  17:08:33  
  17:08:33  Finished running 3 view models, 3 table models, 1 incremental model in 0 hours 0 minutes and 26.77 seconds (26.77s).
  17:08:33  
  17:08:33  Completed successfully
  17:08:33  
  17:08:33  Done. PASS=7 WARN=0 ERROR=0 SKIP=0 TOTAL=7
```

![](/img/62.png)

Now that we are done with our basic modeling, let's clean up the materialization settings.

--- 

In this explanation, we will fix the project-level materialization settings in our dbt project to ensure that source layer models are not materialized as tables or views but instead are treated as ephemeral models. Ephemeral models are not materialized directly in the database; instead, their SQL is inlined into the models that reference them.

First, we will fix the project-level materialization. In the source layer, as discussed, we don't need any tables to be materialized permanently. Therefore, we will set the materialization to `ephemeral` for the source layer.

`dbt_project.yml`:

```yaml
models:
  dbt_learn:
    +materialized: view
    dim:
      +materialized: table
    src:
      +materialized: ephemeral
```

When I execute `dbt run` now, every model in the source layer will be converted to CTEs and won't be recreated as views. Here you can see the process:

- The development models and the dimension tables will be recreated.
- No materialization changes will occur for the source models, even though they are still part of the project.

Here is an example output of running `dbt run`:

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run                      
  06:59:46  Running with dbt=1.7.17
  06:59:46  Registered adapter: snowflake=1.7.1
  06:59:47  Found 7 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  06:59:47  
  06:59:52  Concurrency: 1 threads (target='dev')
  06:59:52  
  06:59:52  1 of 4 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
  06:59:55  1 of 4 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 2.63s]
  06:59:55  2 of 4 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
  06:59:57  2 of 4 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 2.31s]
  06:59:57  3 of 4 START sql incremental model DEV.fct_reviews ............................. [RUN]
  07:00:01  3 of 4 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 0 in 3.71s]
  07:00:01  4 of 4 START sql table model DEV.dim_listings_w_hosts .......................... [RUN]
  07:00:03  4 of 4 OK created sql table model DEV.dim_listings_w_hosts ..................... [SUCCESS 1 in 2.32s]
  07:00:03  
  07:00:03  Finished running 3 table models, 1 incremental model in 0 hours 0 minutes and 16.83 seconds (16.83s).
  07:00:03  
  07:00:03  Completed successfully
  07:00:03  
  07:00:03  Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

You can see, when I executed dbt run:
```sh
1 of 4 OK created sql table model DEV.dim_hosts_cleansed
2 of 4 OK created sql table model DEV.dim_listings_cleansed
3 of 4 OK created sql incremental model DEV.fct_reviews
4 of 4 OK created sql table model DEV.dim_listings_w_hosts
```

Then every model in the source layer will be converted to CTEs and won't be recreated as views. The development models and the dimension tables will be recreated, right? And that's very much it. No materialization changes will occur for the source models, even though they are still part of the project.

To verify this behavior, you can check the current views in Snowflake. If you still see views for the source models, it means they were not automatically dropped. You'll need to manually drop these views. After doing so, running dbt run again will ensure that these views are not recreated, confirming that the source models are now correctly treated as ephemeral models

![](/img/58.png)

The reason for this is that dbt will not automatically drop views or tables in these cases. So you need to do it yourself. 

![](/img/59.png)

Let's go ahead and drop these views. Here we go. Now, these views are dropped. So if I come back and execute dbt run again, we will see that these views will not be recreated. So here we go. Refresh, no views, right?

So that's it now. These are ephemeral models, right?


```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run        

14:48:00  Running with dbt=1.7.17
14:48:00  Registered adapter: snowflake=1.7.1
14:48:01  Found 7 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
14:48:01  
14:48:03  Concurrency: 1 threads (target='dev')
14:48:03  
14:48:03  1 of 4 START sql table model DEV.dim_hosts_cleansed ............................ [RUN]
14:48:05  1 of 4 OK created sql table model DEV.dim_hosts_cleansed ....................... [SUCCESS 1 in 1.90s]
14:48:05  2 of 4 START sql table model DEV.dim_listings_cleansed ......................... [RUN]
14:48:07  2 of 4 OK created sql table model DEV.dim_listings_cleansed .................... [SUCCESS 1 in 1.92s]
14:48:07  3 of 4 START sql incremental model DEV.fct_reviews ............................. [RUN]
14:48:10  3 of 4 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 0 in 3.35s]
14:48:10  4 of 4 START sql table model DEV.dim_listings_w_hosts .......................... [RUN]
14:48:12  4 of 4 OK created sql table model DEV.dim_listings_w_hosts ..................... [SUCCESS 1 in 1.97s]
14:48:12  
14:48:12  Finished running 3 table models, 1 incremental model in 0 hours 0 minutes and 11.72 seconds (11.72s).
14:48:12  
14:48:12  Completed successfully
14:48:12  
14:48:12  Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4

```

And if you take a look, you'll remember that in the project properties, we have a target path defined, right?

So it says that the target path is target or the compound directory qualifies to be there.

```yml
target-path: "target"  # directory which will store compiled SQL files
clean-targets:         # directories to be removed by `dbt clean`
  - "target"
  - "dbt_packages"
```

```sh
├── target
│   ├── compiled
│   │   └── dbt_learn
│   │       └── models
│   │           ├── dim
│   │           │   ├── dim_hosts_cleansed.sql
│   │           │   ├── dim_listings_cleansed.sql
│   │           │   └── dim_listings_w_hosts.sql
│   │           ├── fct
│   │           │   └── fct_reviews.sql
│   │           └── src
│   │               ├── src_hosts.sql
│   │               ├── src_listings.sql
│   │               └── src_reviews.sql
```

Project properties, we have a target folder defined, right? So it says that the target path is target. All the compiled SQL files will be there. So if I take a look and I say just check from target, I have a folder called run, and in the run I have the models, and in models I have, here we go, let's say some DIM tables, and let's take a look at the DIM listings cleansed, for example. So if I take a look at the final compiled SQL, the SQL that dbt actually executes in Snowflake, I will find it here and I will be able to check it. So let's take a look, and here we are. 

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ ls -la target/run/dbt_learn/models/dim/                   

-rw-r--r--  1 alex  staff  567 Jul 13 17:00 dim_hosts_cleansed.sql
-rw-r--r--  1 alex  staff  808 Jul 13 17:00 dim_listings_cleansed.sql
-rw-r--r--  1 alex  staff  564 Jul 13 17:00 dim_listings_w_hosts.sql

(dbt_env) ➜  dbt_learn git:(main) ✗ code target/run/dbt_learn/models/dim/dim_listings_cleansed.sql 
```

So this is now the DIMM listing cleansed. This is the actual SQL that was passed to Snowflake. So here you see it says we created the DIM listings cleansed, and here is a CT, it says this is a dbtct src listing, an internal identifier which has the listing CT and then the listings cleansed script. So this is where everything gets together. If you ever want to debug a dbt run, then your target folder is where you want to take a look at what dbt executed against Snowflake.

---

The last thing I want to show you is how you can convert some of our DIM models into Views. 

```sh
├── target
│   ├── compiled
│   │   └── dbt_learn
│   │       └── models
│   │           ├── dim
│   │           │   ├── dim_hosts_cleansed.sql
│   │           │   ├── dim_listings_cleansed.sql
│   │           │   └── dim_listings_w_hosts.sql
```

Now you already know, if you take a look at the Factory Views table, how to create a file level config. I will simply go on and take `dim_Listings_cleansed` and `dim_hosts_cleansed` and make sure that those are materialized as Views.

And the way to go will be simply just adding this materialization `config `here, saying that I don't want these to be materialized as Tables, I want these to be materialized as Views, like this. Okay, let's go ahead and do the same with the Hosts table.

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/dim/dim_listings_cleansed.sql 

  -- models/dim/dim_hosts_cleansed.sql
  {{
    config(
      materialized = 'view'
      )
  }} 
  WITH src_hosts AS (
      SELECT
          *
      FROM
          {{ ref('src_hosts') }}
  )
  SELECT
      host_id,
      NVL(
          host_name,
          'Anonymous'
      ) AS host_name,
      is_superhost,
      created_at,
      updated_at
  FROM
      src_hosts
```

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/dim/dim_listings_cleansed.sql 

  -- models/dim/dim_listings_cleansed.sql
  {{
    config(
      materialized = 'view'
      )
  }} 
  WITH src_listings AS (
      SELECT * FROM {{ ref('src_listings') }}
  )
  SELECT 
    listing_id,
    listing_name,
    room_type,
    CASE
      WHEN minimum_nights = 0 THEN 1
      ELSE minimum_nights
    END AS minimum_nights,
    host_id,
    REPLACE(
      price_str,
      '$'
    ) :: NUMBER(
      10,
      2
    ) AS price,
    created_at,
    updated_at
  FROM
    src_listings
```

So `dim_listings_w_host` materializers table, because everything in `/dim/` is by default materialized as table, right? Based on my project YAML. And `factory` views materializes an incremental table, and `dim_listings_cleansed`, and `dim_hosts_cleaned`, materializes views. And `SRC` listings not materialized at all, so materializes ephemeral. 

So let's execute DBT for the last time, and make sure that we have now views instead of tables.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run

  18:02:21  Running with dbt=1.7.17
  18:02:22  Registered adapter: snowflake=1.7.1
  18:02:22  Found 7 models, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  18:02:22  
  18:02:25  Concurrency: 1 threads (target='dev')
  18:02:25  
  18:02:25  1 of 4 START sql view model DEV.dim_hosts_cleansed ............................. [RUN]
  18:02:26  1 of 4 OK created sql view model DEV.dim_hosts_cleansed ........................ [SUCCESS 1 in 1.66s]
  18:02:26  2 of 4 START sql view model DEV.dim_listings_cleansed .......................... [RUN]
  18:02:28  2 of 4 OK created sql view model DEV.dim_listings_cleansed ..................... [SUCCESS 1 in 1.31s]
  18:02:28  3 of 4 START sql incremental model DEV.fct_reviews ............................. [RUN]
  18:02:31  3 of 4 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 0 in 3.50s]
  18:02:31  4 of 4 START sql table model DEV.dim_listings_w_hosts .......................... [RUN]
  18:02:34  4 of 4 OK created sql table model DEV.dim_listings_w_hosts ..................... [SUCCESS 1 in 2.47s]
  18:02:34  
  18:02:34  Finished running 2 view models, 1 incremental model, 1 table model in 0 hours 0 minutes and 11.60 seconds (11.60s).
  18:02:34  
  18:02:34  Completed successfully
  18:02:34  
  18:02:34  Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

Now we have it like views

![](/img/63.png)



### Seeds and Sources

LEARNING OBJECTIVES
* Understand the difference between seeds and sources
* Understand source-freshness
* Integrate sources into our project

**Seeds and Sources OVERVIEW**

* Seeds are local files that you upload to the data warehouse from dbt
* Sources is an abstraction layer on the top of your input tables
* Source freshness can be checked automatically


When you do modeling in DBT, your input data can come from two sources. 
* Either it's already in the data warehouse, having been integrated by an integration tool like FileStream, AirByte, or any custom ETL tool or ETL process. 
* Or, it's a smaller dataset that you want to send directly from your laptop to the data warehouse, which is called a seed. 

If the data is already in the data warehouse, it is called a source in DBT. DBT provides tools for defining seeds and sources and ensuring that your sources are up-to-date and alerting you to stale or outdated sources. Let's see how this works in practice.

#### Seeds

Seeds are smaller datasets that live in the seeds folder as CSV files. First, ensure that your dbt_project.yml file specifies the seeds folder correctly. 

```yml
# These configurations specify where dbt should look for different types of files.
# The `model-paths` config, for example, states that models in this project can be
# found in the "models/" directory. You probably won't need to change these!
seed-paths: ["seeds"]
```
If you have a folder named data, please rename it to seeds. Next, we will take a CSV file, which you can get from the class resources or other sources, and copy it to the seeds folder. 

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ curl https://dbtlearn.s3.us-east-2.amazonaws.com/seed_full_moon_dates.csv -o seeds/seed_full_moon_dates.csv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3007  100  3007    0     0    845      0  0:00:03  0:00:03 --:--:--   845
```

```sh
├── seeds
│   └── seed_full_moon_dates.csv
```
In this .csv there are the day is for the last 10 years or so where there was a full moon. Now, what we are after is to check if people give more negative results after full_moon_dat.

We will then upload it to Snowflake through DBT. It's a simple process. Let's go ahead and populate our seeds folder with the CSV file. I have a CSV file ready. Now, let me go to my terminal.

You see that this year is a single currency week, but you don't necessarily need to work with a single


```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt seed
18:23:24  Running with dbt=1.7.17
18:23:24  Registered adapter: snowflake=1.7.1
18:23:25  Found 7 models, 1 seed, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
18:23:25  
18:23:30  Concurrency: 1 threads (target='dev')
18:23:30  
18:23:30  1 of 1 START seed file DEV.seed_full_moon_dates ................................ [RUN]
18:23:34  1 of 1 OK loaded seed file DEV.seed_full_moon_dates ............................ [INSERT 272 in 3.23s]
18:23:34  
18:23:34  Finished running 1 seed in 0 hours 0 minutes and 8.95 seconds (8.95s).
18:23:34  
18:23:34  Completed successfully
18:23:34  
18:23:34  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

![](/img/64.png)

DBT internally analyzes your CSV files and automatically determines the schema, including the data types of columns.

---

Now we are ready to implement our fourth layer, which will be our Mart layer. The Mart layer typically contains tables and views accessible by BI tools.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/mart/mart_full_moon_reviews.sql

  {{ config(
    materialized = 'table',
  ) }}

  WITH fct_reviews AS (
      SELECT * FROM {{ ref('fct_reviews') }}
  ),
  full_moon_dates AS (
      SELECT * FROM {{ ref('seed_full_moon_dates') }}
  )

  SELECT
    r.*,
    CASE
      WHEN fm.full_moon_date IS NULL THEN 'not full moon'
      ELSE 'full moon'
    END AS is_full_moon
  FROM
    fct_reviews
    r
    LEFT JOIN full_moon_dates
    fm
    ON (TO_DATE(r.review_date) = DATEADD(DAY, 1, fm.full_moon_date))
```

* Configures the model to be materialized as a table.
* Creates two Common Table Expressions (CTEs):
  * `fct_reviews`: Selects all data from the fct_reviews table.
  * `full_moon_dates`: Selects all data from the seed_full_moon_dates seed.
* Performs a LEFT JOIN between fct_reviews and full_moon_dates, matching review dates with the day after a full moon date.
* Adds a column is_full_moon to indicate whether the review date is the day after a full moon ('full moon') or not ('not full moon').

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run
  18:42:10  Running with dbt=1.7.17
  18:42:11  Registered adapter: snowflake=1.7.1
  18:42:11  Found 8 models, 1 seed, 0 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  18:42:11  
  18:42:13  Concurrency: 1 threads (target='dev')
  18:42:13  
  18:42:14  1 of 5 START sql view model DEV.dim_hosts_cleansed ............................. [RUN]
  18:42:15  1 of 5 OK created sql view model DEV.dim_hosts_cleansed ........................ [SUCCESS 1 in 1.33s]
  18:42:15  2 of 5 START sql view model DEV.dim_listings_cleansed .......................... [RUN]
  18:42:16  2 of 5 OK created sql view model DEV.dim_listings_cleansed ..................... [SUCCESS 1 in 1.30s]
  18:42:16  3 of 5 START sql incremental model DEV.fct_reviews ............................. [RUN]
  18:42:20  3 of 5 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 0 in 3.63s]
  18:42:20  4 of 5 START sql table model DEV.dim_listings_w_hosts .......................... [RUN]
  18:42:22  4 of 5 OK created sql table model DEV.dim_listings_w_hosts ..................... [SUCCESS 1 in 2.39s]
  18:42:22  5 of 5 START sql table model DEV.mart_full_moon_reviews ........................ [RUN]
  18:42:27  5 of 5 OK created sql table model DEV.mart_full_moon_reviews ................... [SUCCESS 1 in 4.61s]
  18:42:27  
  18:42:27  Finished running 2 view models, 1 incremental model, 2 table models in 0 hours 0 minutes and 15.98 seconds (15.98s).
  18:42:27  
  18:42:27  Completed successfully
  18:42:27  
  18:42:27  Done. PASS=5 WARN=0 ERROR=0 SKIP=0 TOTAL=5
```

![](/img/65.png)

#### Sources

Let's convert our raw tables into sources. Sources are an abstraction on top of your input data, providing extra features like data freshness checks. Additionally, as you will see later in the documentation, sources appear as special entities. This process will not change the actual behavior of DBT or the queries it executes, but it will make our project more structured.

To define sources, follow these steps:

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/sources.yml
version: 2

sources:
  - name: airbnb
    schema: raw
    tables:
      - name: listings
        identifier: raw_listings

      - name: hosts
        identifier: raw_hosts

      - name: reviews
        identifier: raw_reviews
```

* sources: Defines the list of sources.
  * name: airbnb: The name of the source. This creates a namespace for the source tables.
  * schema: raw: Specifies the schema in the database where the source tables are located.
  * tables: Lists the tables included in the source.
    * name: listings: The name by which the table will be referenced in DBT.
    * identifier: raw_listings: The actual name of the table in the database.
<br>  
    * name: hosts: The name by which the table will be referenced in DBT.
    * identifier: raw_hosts: The actual name of the table in the database.
<br> 
    * name: reviews: The name by which the table will be referenced in DBT.
    * identifier: raw_reviews: The actual name of the table in the database.


In DBT, configuring sources adds an abstraction layer over raw tables, enhancing project structure and organization. It allows easy referencing of tables as sources, enables freshness checks to ensure data is up-to-date, and improves documentation and data traceability. This setup simplifies maintenance and schema change management, without altering query behavior, but structures the project more efficiently and robustly.

Let's go to my source there was because here I found those motors which refer and throw them both.

```sh
│   └── src
│       ├── src_hosts.sql
│       ├── src_listings.sql
│       └── src_reviews.sql
```

So if I open raw listings.  Then you will see that here `SELECT * FROM AIRBNB.RAW.RAW_LISTINGS` we use a direct reference to our snowflake is right. 

```SQL
WITH raw_listings AS (
    SELECT * FROM AIRBNB.RAW.RAW_LISTINGS
)
SELECT ...
```

What happens if these tables move or you have different instances using different schemas? This is where sources and this abstraction help you. By using sources, you can simplify your references. For example, instead of directly referencing a table, you reference your sources. We pass the source name, such as bmb, and then, in our case, listings. 

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat /Users/alex/Desktop/DataEngineer_dbt_Bootcamp/dbt_learn/models/src/src_listings.sql

  WITH raw_listings AS (
      SELECT * FROM {{ source('airbnb', 'listings') }}
  )
  SELECT ...
```

This way, DBT will recognize that you are referring to `raw` through the alias `airbnb`. You can do the same with raw_hosts host in the hosts file and with raw_reviews. 

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat /Users/alex/Desktop/DataEngineer_dbt_Bootcamp/dbt_learn/models/src/src_hosts.sql   

WITH raw_hosts AS (
    SELECT * FROM {{ source('airbnb', 'hosts') }}
)
SELECT
    id AS host_id,
    NAME AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
```

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat /Users/alex/Desktop/DataEngineer_dbt_Bootcamp/dbt_learn/models/src/src_reviews.sql

WITH raw_reviews AS (
    SELECT * FROM {{ source('airbnb', 'reviews') }}
SELECT
    listing_id,
    date AS review_date,
    reviewer_name,
    comments AS review_text,
    sentiment AS review_sentiment
FROM
    raw_reviews
```

This makes the project more structured. Let's see if it works.

I will not execute this with dbt run, because we have another command just for checking if all the template tags and the connections and everything we defined in our project make sense. This is called dbt, dbt compile. With dbt compile, dbt goes through all of your models, the YAML files and tests and all, and it will check if all of the references and template tags and everything is correct. And it says, OK.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt compile
19:26:04  Running with dbt=1.7.17
19:26:05  Registered adapter: snowflake=1.7.1
19:26:05  Found 8 models, 1 seed, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
19:26:05  
19:26:06  Concurrency: 1 threads (target='dev')
19:26:06  
```

#### Sources Freshness

In a production setting, you probably want to have some kind of monitoring in place to ensure that your data ingestion works on schedule and correctly. One way to do this is to check the last timestamp of the ingested data. If the ingested data is somewhat stale, it should trigger a warning, and if it is significantly delayed, it should trigger an error. DBT has a built-in functionality called source freshness to help with this.


![](/img/66.png)

Let's see this in action. Here, we have the raw_reviews table, which we converted to a source. This table contains a date column that stores the review date. We can define source freshness constraints in the sources.yml file. Here's an example configuration:

```yml
sources:
  - name: airbnb
    schema: raw
    tables:
      - name: listings
        identifier: raw_listings

      - name: hosts
        identifier: raw_hosts

      - name: reviews
        identifier: raw_reviews
        loaded_at_field: date
        freshness:
          warn_after: {count: 1, period: hour}
          error_after: {count: 24, period: hour}
```
In this configuration:

* `loaded_at_field` points to the column that stores the ingestion timestamp (date in the reviews table).
* `freshness` constraints are defined:
  *` warn_after`: {count: 1, period: hour}: Issues a warning if no data is found within the last hour.
  * `error_after`: {count: 24, period: hour}: Raises an error if no data is found within the last 24 hours.
  * To check the freshness, save your changes and run the following command in your console:
  
```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt source freshness
19:40:21  Running with dbt=1.7.17
19:40:22  Registered adapter: snowflake=1.7.1
19:40:22  Found 8 models, 1 seed, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
19:40:22  
19:40:25  Concurrency: 1 threads (target='dev')
19:40:25  
19:40:25  1 of 1 START freshness of airbnb.reviews ....................................... [RUN]
19:40:26  1 of 1 ERROR STALE freshness of airbnb.reviews ................................. [ERROR STALE in 1.67s]
19:40:26  
19:40:26  Done.
```

DBT will then check the freshness of your data. For example, if you added a new review more than an hour ago, you might receive a warning. If the data is over 24 hours old, you will receive an error.

This setup ensures that your data ingestion processes are closely monitored, and any issues with data freshness are promptly flagged, helping maintain the integrity and reliability of your data pipeline.


### Snapshots

In this section, you will see how DBT helps you maintain historical data as it changes over time. This is accomplished using Type II Slowly Changing Dimensions, a concept we covered in our theoretical lessons. You will learn how DBT handles these Type II Slowly Changing Dimensions and the different snapshotting strategies it supports. We will implement snapshots for both our listings table and our hosts table. So, let's get started.

LEARNING OBJECTIVES
* Understand how dbt handles type-2 slowly changing dimensions
* Understand snapshot strategies
* Learn how to create snapshots on top of our listings and hosts models

**Snapshots Overview**

Let's take a look at how snapshots are implemented in DBT. First, a quick recap of how Slowly Changing Dimensions work. This demo will focus on Type II Slowly Changing Dimensions.

TYPE-2 SLOWLY CHANGING DIMENSIONS

Let's assume you have a dimension table, such as our host table, with entries for Alice and Bob. Bob's email address is initially set to `bob.erbynb@gmail.com`. If Bob updates his email address to `bob.new@gmail.com`, you want to keep a history of this change rather than just overwriting the existing data.

In an analytical data pipeline, maintaining this history is crucial. DBT handles this using Type II Slowly Changing Dimensions, a best practice in the data warehousing world. DBT adds two extra columns to the original table, indicating the start and end timestamps for each record's validity.

How DBT Handles Changes

![](/img/67.png)

1. **Original Record**: Each record has `valid_from` and `valid_to` columns.
2. **Current Record**: For a current record, `valid_to` is `null`.
3. **On Change**: When a change occurs, `valid_to` is set to the date of the change for the existing record, and a new record is created with the new values, `valid_from` set to the change date, and `valid_to` set to `null`.
This method allows you to always see the current version by filtering for valid_to = null and to track the entire history of changes by looking at all records.

**DBT Snapshot Configuration and Strategies**

DBT offers two strategies for implementing Slowly Changing Dimensions:

1. Timestamp Strategy:
   * Requires a unique key on your source table.
   * Uses an updated_at field that stores the last update timestamp.
   * DBT records any changes based on this timestamp.

2. Check Strategy:
   * Does not require an updated_at field.
   * Monitors specified columns (or all columns) for changes.
   * DBT adds new records whenever any of these columns change.

**Implementing Snapshots**

We will now implement snapshots for both our listings table and our hosts table using these strategies. By doing so, we ensure that our data warehouse maintains a comprehensive history of changes, enabling robust analysis and reporting.

#### Creating a Snapshot

In this lesson, we will create two snapshot tables: one for raw listings and another for raw hosts. I'll demonstrate the process using raw listings, and later apply the same steps to raw hosts. Let's get started.

First, it's important to know that the snapshots path is defined in `dbt.project.yml` and should be set to the snapshots folder by default `snapshot-paths: ["snapshots"]`. You shouldn't need to change anything here.

```sh
├── snapshots
├── seeds
│   └── seed_full_moon_dates.csv
```

Next, let's take a look at the raw listings table.  Our goal is to snapshot the `raw data` so we can track any changes right at the source. This way, if any new data comes in or changes occur, we can capture those changes immediately. You can choose different strategies based on your use case, such as snapshotting already cleaned data, but we'll focus on raw data to catch changes as early as possible.

![](/img/68.png)

We have the raw listings table, which contains an ID and various properties, including a `minimum_nights` field and an `updated_at` field. Our aim is to ensure that any changes to a record, identified by the `updated_at` field, are tracked.

Let's create our snapshot. In the snapshots folder, create a new file called `scd_raw_listings.sql`. This is an arbitrary name, and you can choose a different one if you prefer. In this file, we'll define our snapshot.

Here is the snapshot definition you can use:

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ touch snapshots/scd_raw_listings.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ nano snapshots/scd_raw_listings.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ cat snapshots/scd_raw_listings.sql

  {% snapshot scd_raw_listings %}
    {{
      config(
          target_schema='DEV',
          unique_key='id',
          strategy='timestamp',
          updated_at='updated_at',
          invalidate_hard_deletes=True
      )
    }}

    select * FROM {{ source('airbnb', 'listings') }}

  {% endsnapshot %}
```

Explanation of the Snapshot Definition:
* `SELECT Statement`: The basis of a snapshot is a `SELECT` statement, usually a `SELECT * FROM` a source table. Here, it's the Airbnb raw listings table.
* Snapshot Jinja Tags: Enclose your snapshot definition between `{% snapshot %}` tags.
* Configuration Options:
  * `target_schema`: Defines the schema where the snapshot will be stored.
  * `unique_key`: The unique identifier for records in your snapshot.
  * `strategy`: We use a timestamp strategy to track changes.
  * `updated_at`: The column used to identify updates.
  * `invalidate_hard_deletes`: If set to `True`, deleted records from the source table will be marked as deleted in the snapshot by updating the valid_to column to the current snapshot date.

By following these steps, you can create a snapshot that tracks changes to your raw listings data. Apply the same process to create a snapshot for raw hosts.

Feel free to refer to the class resources for additional details and copy the provided definitions. Happy snapshotting!

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt snapshot
18:44:44  Running with dbt=1.7.17
18:44:45  Registered adapter: snowflake=1.7.1
18:44:45  Found 8 models, 1 seed, 1 snapshot, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
18:44:45  
18:44:48  Concurrency: 1 threads (target='dev')
18:44:48  
18:44:48  1 of 1 START snapshot DEV.scd_raw_listings ..................................... [RUN]
18:44:51  1 of 1 OK snapshotted DEV.scd_raw_listings ..................................... [SUCCESS 1 in 2.60s]
18:44:51  
18:44:51  Finished running 1 snapshot in 0 hours 0 minutes and 5.62 seconds (5.62s).
18:44:51  
18:44:51  Completed successfully
18:44:51  
18:44:51  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```



Now that we have our snapshot defined, let's execute the `dbt snapshot` command to create our snapshots. Remember, for snapshotting, you need to run a separate command: `dbt snapshot`, not `dbt run`.

When you execute `dbt snapshot`, it confirms that we have created a snapshot named `dbt_scd_raw_listings`. Let’s refresh our Snowflake tables to verify this. 

Checking the Snapshot Table

![](/img/69.png)

Upon refreshing, you’ll see the `scd_raw_listings` table. This table will have additional columns compared to the original table, including:

- **dbt_scd_id**: A hashed ID used internally.
- **dbt_updated_at**: An internal timestamp column.
- **dbt_valid_from**: Reflects the original `updated_at` value.
- **dbt_valid_to**: Initially set to `NULL` because we’ve just created our initial snapshot.

**Updating the Data**

Next, let’s update the raw data to see how changes are tracked. Here’s a simple query to update the `minimum_nights` value to 30 for the listing ID 3176 and refresh the `updated_at` timestamp:

```sql
UPDATE AIRBNB.RAW.RAW_LISTINGS
SET minimum_nights = 30, updated_at = CURRENT_TIMESTAMP()
WHERE id = 3176;
```

Before executing the update, check the current state of the raw listings table to confirm the change. For instance, if the current `minimum_nights` value for ID 3176 is 62, update it to 30 and refresh the `updated_at` field.

![](/img/70.png)

**Running dbt Snapshot Again**

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt snapshot                      
  19:00:41  Running with dbt=1.7.17
  19:00:41  Registered adapter: snowflake=1.7.1
  19:00:41  Found 8 models, 1 seed, 1 snapshot, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  19:00:41  
  19:00:44  Concurrency: 1 threads (target='dev')
  19:00:44  
  19:00:44  1 of 1 START snapshot DEV.scd_raw_listings ..................................... [RUN]
  19:00:49  1 of 1 OK snapshotted DEV.scd_raw_listings ..................................... [SUCCESS 2 in 5.08s]
  19:00:49  
  19:00:49  Finished running 1 snapshot in 0 hours 0 minutes and 7.90 seconds (7.90s).
  19:00:49  
  19:00:49  Completed successfully
  19:00:49  
  19:00:49  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

After updating the data, re-execute the `dbt snapshot` command. This will:

1. Compare the raw table with the snapshot table.
2. Detect differences.
3. Update the snapshot table accordingly.

**Verifying the Update**

Upon re-executing `dbt snapshot`, check the `scd_raw_listings` table again. You should see two records for the listing ID 3176:

![](/img/72.png)

1. The initial record with `minimum_nights` set to 62 and `dbt_valid_to` updated to today's date.
2. A new record with `minimum_nights` set to 30 and `dbt_valid_to` set to `NULL`.

This process demonstrates how snapshots work in dbt. It’s straightforward and efficient. Personally, I find it impressive because it simplifies the implementation of Slowly Changing Dimensions (SCD) Type 2, which typically requires complex re-implementation in different databases. With dbt, it just works seamlessly.

and it's always something you need to reimplement yourself, figuring out the logic repeatedly. But now, DBT handles it for you, which is perfect. This is a significant improvement.

Another important point to note is the flexibility of DBT when working with different SQL dialects. Most of what we've done so far involves plain SQL, tailored to the specific database platform we're using. For instance, SQL for a Snowflake instance might differ slightly from SQL for a Databricks or MySQL instance. We provided the SQL, and DBT offered the framework.

However, with snapshots, there is more internal SQL logic at play. The process of updating fields in the SCD table and merging new data depends heavily on the underlying technology. In this case, the DBT connector generates the appropriate SQL for Snowflake to make updates. If you were using Databricks Spark SQL, it would use a different approach.

This demonstrates how DBT increasingly integrates into the process, handling more complex logic. I find snapshots particularly impressive and hope you will appreciate them as well.

### Learning objectives - Tests

LEARNING OBJECTIVES
   * Understand how tests can be defined
   * Configure built-in generic tests
   * Create your own singular tests

In this section, you will learn how DBT can help you implement data quality tests. You will understand the DBT testing framework and see how to implement both generic and singular tests in practice. Let's get started.

**Test overview**

In DBT, there are generally two kinds of tests: singular tests and generic tests. The differences between the two are quite subtle.

* **Singular Tests** Singular tests are straightforward. They are simple SQL SELECT statements that you place in your test folder. These SQL queries are expected to return an empty result set. If a singular test returns any records, the test is considered to have failed.

* **Generic Tests** DBT also includes a few built-in tests known as generic tests. There are four main types of built-in generic tests:
  1. **Unique**: Ensures that a column contains only unique values.
  2. **Not Null**: Ensures that a column does not contain null values.
  3. **Accepted Values**: Ensures that a column contains only specific, predefined values.
  4. **Relationships**: Ensures that values in a column are valid references to another column in a different table.

**Custom Generic Tests**  
You can take tests to a more advanced level by writing your own generic tests. This involves using macros, which will be covered in later sections of the course. Additionally, once you learn about DBT packages, you'll see how to install third-party packages and use the tests they provide as generic tests in your DBT project.

**Practical Implementation**  
We'll see how all of this works in practice by implementing a few generic tests and a singular test. You'll then have the opportunity to create your own singular test as part of an exercise. Let's dive in!

#### Implementing Generic Tests in `dim_Listings_Cleaned.sql`

Let's implement a few tests on our `dim_Listings_Cleaned`. As we discussed, there are generic tests and singular tests. Here, I will show you how generic tests work. Generic tests are built-in tests in dbt. They can come from the standard dbt core installation, through CertQuality packages, or your own custom generic test implementation. In this guide, we will go through the four built-in generic tests.

Before we implement these tests, let's take a look at the `DIMM Listings Clean` view. Below is a step-by-step process on how to set up and execute these tests in dbt.

**dim_Listings_Cleaned**

Let’s review the `DIMM Listings Clean` view in Snowflake. Here's a brief description of the columns we are interested in:

- **Listing ID**: This column should not contain any null values and must be unique as it serves as the primary key.
- **Listing Name**: This column should also be not null.
- **Room Type**: This column should contain only preset values such as "entire home or apartment", "private room", or "shared room".
- **Host ID**: This column is an external reference to the host table, so every ID here must correlate to an existing host ID in the host table.

![](/img/73.png)

**Creating the Tests**

We will create a new file named `schema.yaml` in the Models folder. This file will contain the configuration, tests, and documentation for your models. Here’s how you can define the tests:

1. **Create `schema.yaml`**: Create a new file named `schema.yaml` in the Models folder.
2. **Define Config Version**: Indicate the config version.
3. **Define Model and Tests**: Define your model and the tests for individual columns.


Here is the structure of the `schema.yaml` file:

```yml
(dbt_env) ➜  dbt_learn git:(main) ✗ touch models/schema.yml
(dbt_env) ➜  dbt_learn git:(main) ✗ nano models/schema.yml 
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/schema.yml 


version: 2

models:
  - name: dim_listings_cleansed
    columns:

      - name: listing_id
        tests:
          - unique
          - not_null
```

This command will execute the tests defined in the schema.yaml file. The tests will check for constraints such as not_null, unique, and accepted_values, and verify relationships between tables.

If you're interested in the actual SQL queries dbt executes, you can find them in the target folder where your compiled tests are stored.

By following these steps, you can ensure that your dim_Listings_Cleaned table adheres to the necessary data quality standards.

```sh
07:07:05  Running with dbt=1.7.17
07:07:05  Registered adapter: snowflake=1.7.1
07:07:06  Found 8 models, 1 seed, 1 snapshot, 2 tests, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
07:07:06  
07:07:08  Concurrency: 1 threads (target='dev')
07:07:08  
07:07:08  1 of 2 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
07:07:09  1 of 2 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.91s]
07:07:09  2 of 2 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
07:07:11  2 of 2 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.47s]
07:07:11  
07:07:11  Finished running 2 tests in 0 hours 0 minutes and 5.27 seconds (5.27s).
07:07:11  
07:07:11  Completed successfully
07:07:11  
07:07:11  Done. PASS=2 WARN=0 ERROR=0 SKIP=0 TOTAL=2
```

Probably a last word before we move on. In many database technologies, you have these unique and not-null constraints built in automatically. For example, if you use MySQL, you can simply add the not-null constraint or the unique constraint to a column. You don't need to create separate tests for them. However, if you work with new technologies like data lakes, such as Snowflake or Databricks, this can often be a challenge. Many new technologies, cloud platforms, data lakes, and lakehouses, do not support these constraints built in. So, we need to create our own tests for them.

Okay, so the listing ID is done. I will also create a test for the host ID, stating it shouldn't be null. Then, I want to create a relationship test to ensure that every value in my host ID column is a valid reference to the host ID column of the DIM host cleansed model. Simple. Now, I have a relationship defined in a test. If I submit a host ID to the listings table that is not present in the host table, my test will fail.

Next, I will set up a test for the room type. These are the values I use for room types: Entire home/apt, Private room, Shared room, and Hotel room. These are the accepted values. Here, you can see the four built-in tests in dbt: unique, not null, relationship, and accepted values. These are the built-in generic tests. You can always create your own, or when you install a dbt package, the packages might provide you with more tests.

So let's execute these tests. I execute `dbt test` again. Now, you will see that I have five tests. All of these tests are starting, and all of them have passed.

```yaml
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/schema.yml 


version: 2

models:
  - name: dim_listings_cleansed
    description: Cleansed table which contains Airbnb listings.
    columns:

      - name: listing_id
        description: Primary key for the listing
        tests:
          - unique
          - not_null

      - name: host_id
        description: The hosts's id. References the host table.
        tests:
          - not_null
          - relationships:
              to: ref('dim_hosts_cleansed')
              field: host_id

      - name: room_type
        description: Type of the apartment / room
        tests:
          - accepted_values:
              values: ['Entire home/apt',
                      'Private room',
                      'Shared room',
                      'Hotel room']
```

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test

  07:18:12  Running with dbt=1.7.17
  07:18:13  Registered adapter: snowflake=1.7.1
  07:18:13  Found 8 models, 1 seed, 1 snapshot, 5 tests, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  07:18:13  
  07:18:15  Concurrency: 1 threads (target='dev')
  07:18:15  
  07:18:15  1 of 5 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [RUN]
  07:18:16  1 of 5 PASS accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [PASS in 1.26s]
  07:18:16  2 of 5 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
  07:18:17  2 of 5 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.17s]
  07:18:17  3 of 5 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
  07:18:18  3 of 5 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.25s]
  07:18:18  4 of 5 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
  07:18:20  4 of 5 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.46s]
  07:18:20  5 of 5 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
  07:18:21  5 of 5 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.23s]
  07:18:21  
  07:18:21  Finished running 5 tests in 0 hours 0 minutes and 8.30 seconds (8.30s).
  07:18:21  
  07:18:21  Completed successfully
  07:18:21  
  07:18:21  Done. PASS=5 WARN=0 ERROR=0 SKIP=0 TOTAL=5
```


`values: ['Entire home/apt`
`values: ['Entire home/apt - beark the model`


**Debugging a Test in dbt**

Okay, so let's go ahead. Let me show you how you would debug a certain test. I can come here and intentionally break a test. For instance, I will modify the room type value to `entire home/apt`, but it will not be in my accepted values definition. Now, let's run `dbt test`.

* `values: ['Entire home/apt`
* `values: ['Entire home/apt - beark the model`
* 
```yml
      - name: room_type
        description: Type of the apartment / room
        tests:
          - accepted_values:
              values: ['Entire home/apt - beark the model',
                      'Private room',
                      'Shared room',
                      'Hotel room']
```

Every time you debug a test, you can review the SQL generated by dbt. This simplicity and transparency are the beauty of dbt, making the whole infrastructure easy to work with. These are generic tests, and you can see how you can debug and understand the underlying processes.

Let's correct the error and rerun the test. Ensure that all the values in your accepted values list are accurate and reflect the actual data.

Now, let's execute dbt test again:



```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test

07:36:09  Running with dbt=1.7.17
07:36:10  Registered adapter: snowflake=1.7.1
07:36:10  Found 8 models, 1 seed, 1 snapshot, 5 tests, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
07:36:10  
07:36:12  Concurrency: 1 threads (target='dev')
07:36:12  
07:36:12  1 of 5 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt_beark_the_model__Private_room__Shared_room__Hotel_room  [RUN]
07:36:14  1 of 5 FAIL 1 accepted_values_dim_listings_cleansed_room_type__Entire_home_apt_beark_the_model__Private_room__Shared_room__Hotel_room  [FAIL 1 in 1.88s]
07:36:14  2 of 5 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
07:36:15  2 of 5 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.12s]
07:36:15  3 of 5 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
07:36:16  3 of 5 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.15s]
07:36:16  4 of 5 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
07:36:17  4 of 5 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.33s]
07:36:17  5 of 5 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
07:36:19  5 of 5 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.28s]
07:36:19  
07:36:19  Finished running 5 tests in 0 hours 0 minutes and 8.79 seconds (8.79s).
07:36:19  
07:36:19  Completed with 1 error and 0 warnings:
07:36:19  
07:36:19  Failure in test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt_beark_the_model__Private_room__Shared_room__Hotel_room (models/schema.yml)
07:36:19    Got 1 result, configured to fail if != 0
07:36:19  
07:36:19    compiled Code at target/compiled/dbt_learn/models/schema.yml/accepted_values_dim_listings_c_e28eca9f72de66744937dbb743f42b83.sql
07:36:19  
07:36:19  Done. PASS=4 WARN=0 ERROR=1 SKIP=0 TOTAL=5
``` 

Tests are getting executed, right? And let's see the results. There we go. The test failed. You also get the test SQL. This is what I wanted to show you. You can open this in your code editor, but I will display it in the terminal.

`07:36:19    compiled Code at target/compiled/dbt_learn/models/schema.yml/accepted_values_dim_listings_c_e28eca9f72de66744937dbb743f42b83.sql`

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat target/compiled/dbt_learn/models/schema.yml/accepted_values_dim_listings_c_e28eca9f72de66744937dbb743f42b83.sql

    
    

with all_values as (

    select
        room_type as value_field,
        count(*) as n_records

    from AIRBNB.DEV.dim_listings_cleansed
    group by room_type

)

select *
from all_values
where value_field not in (
    'Entire home/apt - beark the model','Private room','Shared room','Hotel room'
)

```

Every time you debug a test, you can review the SQL generated by dbt. This simplicity and transparency are the beauty of dbt, making the whole infrastructure easy to work with. These are generic tests, and you can see how you can debug and understand the underlying processes.

Let's correct the error and rerun the test. Ensure that all the values in your accepted values list are accurate and reflect the actual data.

#### Singular Tests

These tests are straightforward. You can define any SQL statement in an SQL file, which will be used as a test. For the test to pass, the file must result in zero returned records. Let me show you an example. Ensure you are back with a proper generic test here. Previously, I broke the entire on-flash APT, and now we move on to our first singular test. Singular tests reside in the Tests folder as SQL files. I'll create a new file called DimListingsMinimumNights.sql. This test checks if the constraint that the minimum nights in the listings table must be greater than zero is upheld.

```SQL
(dbt_env) ➜  dbt_learn git:(main) touch tests/dim_listings_minimum_nigths.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ cat tests/dim_listings_minimum_nigths.sql

SELECT
    *
FROM
    {{ ref('dim_listings_cleansed') }}
WHERE minimum_nights < 1
LIMIT 10
```

Here's the SQL query: I select every record from the listings where the minimum nights are less than one. If all minimum nights records are greater than zero, the test will pass. I've saved the file and can now execute the test. You will see that we have six tests, including our new test, DimListingsMinimumNights.

In this specific case, the test is checking that there are no values in the minimum_nights column that are less than 1. This is important because a value less than 1 could indicate a data error, given that in the context of "minimum nights," it makes sense to expect the values to be at least 1 or greater.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test
14:40:21  Running with dbt=1.7.17
14:40:21  Registered adapter: snowflake=1.7.1
14:40:21  Found 8 models, 1 seed, 1 snapshot, 6 tests, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
14:40:21  
14:40:23  Concurrency: 1 threads (target='dev')
14:40:23  
14:40:23  1 of 6 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [RUN]
14:40:24  1 of 6 PASS accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [PASS in 1.41s]
14:40:24  2 of 6 START test dim_listings_minimum_nigths .................................. [RUN]
14:40:26  2 of 6 PASS dim_listings_minimum_nigths ........................................ [PASS in 1.55s]
14:40:26  3 of 6 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
14:40:27  3 of 6 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.23s]
14:40:27  4 of 6 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
14:40:28  4 of 6 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.32s]
14:40:28  5 of 6 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
14:40:30  5 of 6 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.31s]
14:40:30  6 of 6 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
14:40:31  6 of 6 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.26s]
14:40:31  
14:40:31  Finished running 6 tests in 0 hours 0 minutes and 9.61 seconds (9.61s).
14:40:31  
14:40:31  Completed successfully
14:40:31  
14:40:31  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```

I have executed all the tests, but I can restrict the execution to tests concerning a specific model. For example, you can look at the dbt-test--help documentation to see how it works. We have select properties, allowing us to execute specific tests. Using dbt-test-select, I can run only the tests related to DimListings. Executing this command will run four tests, all for DimListings, including DimListingsMinimumNights.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test --select dim_listings_cleansed

  14:43:01  Running with dbt=1.7.17
  14:43:02  Registered adapter: snowflake=1.7.1
  14:43:02  Found 8 models, 1 seed, 1 snapshot, 6 tests, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
  14:43:02  
  14:43:07  Concurrency: 1 threads (target='dev')
  14:43:07  
  14:43:07  1 of 6 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [RUN]
  14:43:08  1 of 6 PASS accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [PASS in 1.32s]
  14:43:08  2 of 6 START test dim_listings_minimum_nigths .................................. [RUN]
  14:43:09  2 of 6 PASS dim_listings_minimum_nigths ........................................ [PASS in 1.27s]
  14:43:09  3 of 6 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
  14:43:10  3 of 6 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.20s]
  14:43:10  4 of 6 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
  14:43:12  4 of 6 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.21s]
  14:43:12  5 of 6 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
  14:43:13  5 of 6 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.66s]
  14:43:13  6 of 6 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
  14:43:15  6 of 6 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.23s]
  14:43:15  
  14:43:15  Finished running 6 tests in 0 hours 0 minutes and 12.56 seconds (12.56s).
  14:43:15  
  14:43:15  Completed successfully
  14:43:15  
  14:43:15  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```

These are singular tests, very simple, and you will have the chance to try them out yourself in the next exercise.


```SQL
(dbt_env) ➜  dbt_learn git:(main) touch tests/dim_hosts_is_superhosts.sql
(dbt_env) ➜  dbt_learn git:(main) ✗ cat tests/dim_hosts_is_superhosts.sql

SELECT *
FROM {{ ref('dim_hosts_cleansed') }}
WHERE is_superhost NOT IN ('t', 'f')
LIMIT 10
```

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test --select dim_hosts_cleansed     
15:02:40  Running with dbt=1.7.17
15:02:40  Registered adapter: snowflake=1.7.1
15:02:41  Found 8 models, 1 seed, 1 snapshot, 7 tests, 3 sources, 0 exposures, 0 metrics, 546 macros, 0 groups, 0 semantic models
15:02:41  
15:02:42  Concurrency: 1 threads (target='dev')
15:02:42  
15:02:42  1 of 2 START test dim_hosts_is_superhosts ...................................... [RUN]
15:02:44  1 of 2 PASS dim_hosts_is_superhosts ............................................ [PASS in 1.53s]
15:02:44  2 of 2 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
15:02:45  2 of 2 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.33s]
15:02:45  
15:02:45  Finished running 2 tests in 0 hours 0 minutes and 4.43 seconds (4.43s).
15:02:45  
15:02:45  Completed successfully
15:02:45  
15:02:45  Done. PASS=2 WARN=0 ERROR=0 SKIP=0 TOTAL=2
```

### Macros, custom tests and packages

In this section, we will discuss macros, custom tests, and packages. By the end, 
* you will understand what macros are and how to create your own. 
* You will also learn how to use these macros to create custom generic tests 
* and how to import macros, generic tests, and other elements from third-party GPT packages. 

Let's get started with 

* Macros are jinja templates created in the macros folder
* There are many built-in macros in DBT
* You can use macros in model definitions and tests
* A special macro, called test, can be used for implementing your own generic tests
* dbt packages can be installed easily to get access to a plethora of macros and tests

The aim of this section is to guide you from creating a simple macro to using it as a custom test, progressing to custom generic tests, and finally working with packaging. 

You will learn that macros are essentially Jinja templates stored in the macros folder, and GPT already includes a variety of built-in macros. By using a special macro called a test, you can create your own generic tests. Additionally, if you need more, you can search for third-party packages to import macros and tests created by others.

**Creating our First Macro**

We are setting up a macro to use as a singular test. This macro is not yet an official generic test. We will create the macro and use it arbitrarily for this purpose. Macros are stored in the macros folder, so let's create a new file there called no-nulls-in-columns. This macro will take a model name and check all its columns to see if any contain null values.

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat macros/no_nulls_in_columns.sql

{% macro no_nulls_in_columns(model) %}
    SELECT * FROM {{ model }} WHERE
    {% for col in adapter.get_columns_in_relation(model) -%}
        {{ col.column }} IS NULL OR
    {% endfor %}
    FALSE
{% endmacro %} 
```
Here is the macro, written as a Jinja template in GPT. If you want to learn about creating control structures like loops or conditions in Jinja, you can refer to the Jinja documentation. In Jinja, you can create variables, use built-in functions, and more. GPT also includes many built-in macros and functions.


Let's explore what this macro does. Named `no_nulls_in_columns`, it takes a single parameter, a model, much like a standard function in a programming language or an SQL function. 

The macro constructs a SQL `SELECT` statement that iterates through every column in the model. The function `adapter.get_columns_in_relation(model)`—a built-in dbt functionality—retrieves all columns from the model. If you're interested in how different adapters like Snowflake or Databricks work, you can check their respective documentation.

As we iterate through each column, the macro builds a condition to check if the column value is null. For example, it checks if the first column is null, then moves to the next column, and so on. The final SQL checks if any column contains a null value. At the end of the iteration, we add `FALSE` to ensure the query is syntactically valid, even if it's a single-column table.

The macro ends with the keyword `endmacro`. The hyphen (`-`) in Jinja templates trims any trailing white spaces, making the expression concise. You can use this hyphen anywhere in the template to ensure clean formatting.


Now, if we go back to the terminal and execute our test, you will see that GPT has identified 180 macros.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test --select dim_listings_cleansed  

15:17:15  Running with dbt=1.7.17
15:17:16  Registered adapter: snowflake=1.7.1
15:17:16  Found 8 models, 1 seed, 1 snapshot, 7 tests, 3 sources, 0 exposures, 0 metrics, 547 macros, 0 groups, 0 semantic models
15:17:16  
15:17:22  Concurrency: 1 threads (target='dev')
15:17:22  
15:17:22  1 of 6 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [RUN]
15:17:23  1 of 6 PASS accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [PASS in 1.40s]
15:17:23  2 of 6 START test dim_listings_minimum_nigths .................................. [RUN]
15:17:25  2 of 6 PASS dim_listings_minimum_nigths ........................................ [PASS in 1.39s]
15:17:25  3 of 6 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
15:17:26  3 of 6 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.35s]
15:17:26  4 of 6 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
15:17:27  4 of 6 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.20s]
15:17:27  5 of 6 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
15:17:29  5 of 6 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.47s]
15:17:29  6 of 6 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
15:17:30  6 of 6 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.21s]
15:17:30  
15:17:30  Finished running 6 tests in 0 hours 0 minutes and 13.98 seconds (13.98s).
15:17:30  
15:17:30  Completed successfully
15:17:30  
15:17:30  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```

With the macro in place, let's create a singular model from it. We'll use `no_nulls_in_columns` to create a new test. Navigate to the tests directory and create a file named `no_nulls_in_dimListings.sql`. 

To refer to the macro, use double curly braces, similar to ref. The syntax looks like this: {{ no_nulls_in_columns(ref('dimListings.cleans')) }}. Here, we reference the model dimListings.cleans using ref.

```SQL
(dbt_env) ➜  dbt_learn git:(main) ✗ cat tests/no_nulls_in_dim_listings.sql 

  {{ no_nulls_in_columns(ref('dim_listings_cleansed')) }}
```

Now that the macro is set up, let's execute all the tests to ensure everything works correctly.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test --select dim_listings_cleansed

  15:31:59  Running with dbt=1.7.17
  15:32:00  Registered adapter: snowflake=1.7.1
  15:32:00  Found 8 models, 1 seed, 1 snapshot, 8 tests, 3 sources, 0 exposures, 0 metrics, 547 macros, 0 groups, 0 semantic models
  15:32:00  
  15:32:05  Concurrency: 1 threads (target='dev')
  15:32:05  
  15:32:05  1 of 7 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [RUN]
  15:32:06  1 of 7 PASS accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [PASS in 1.23s]
  15:32:06  2 of 7 START test dim_listings_minimum_nigths .................................. [RUN]
  15:32:07  2 of 7 PASS dim_listings_minimum_nigths ........................................ [PASS in 1.20s]
  15:32:07  3 of 7 START test no_nulls_in_dim_listings ..................................... [RUN]
  15:32:09  3 of 7 PASS no_nulls_in_dim_listings ........................................... [PASS in 2.05s]
  15:32:09  4 of 7 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
  15:32:10  4 of 7 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.21s]
  15:32:10  5 of 7 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
  15:32:11  5 of 7 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.23s]
  15:32:11  6 of 7 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
  15:32:13  6 of 7 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.24s]
  15:32:13  7 of 7 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
  15:32:14  7 of 7 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.30s]
  15:32:14  
  15:32:14  Finished running 7 tests in 0 hours 0 minutes and 13.87 seconds (13.87s).
  15:32:14  
  15:32:14  Completed successfully
  15:32:14  
  15:32:14  Done. PASS=7 WARN=0 ERROR=0 SKIP=0 TOTAL=7
```

**Writing Custom Generic Tests**

Custom generic tests are essentially macros with a special signature. By using this signature, you can add these macro names into your YAML file, such as `schema.yml`, and use them as generic tests. For instance, the test for `dim_listings_minimum_nigths`, which ensures that `minimum nights` values are positive, is a good candidate for a custom generic test. Let's create this test.

Custom generic tests reside in the macros folder since they are macros. I'll create a new file named `macros/positiveValue.sql`. Here’s the custom generic test, which you can also find in the class resources:

```sql
(dbt_env) ➜  dbt_learn git:(main) ✗ touch macros/positive_value.sql       
(dbt_env) ➜  dbt_learn git:(main) ✗ cat macros/positive_value.sql

  {% test positive_value(model, column_name) %}
  SELECT
      *
  FROM
      {{ model }}
  WHERE
      {{ column_name}} < 1
  {% endtest %}
```

This macro has a special signature indicating it is a test. It is named `positive_value`, though the actual name used in your SQL can be different. The critical part is the macro name. The macro takes two parameters: `model` and `column_name`. When added to your `schema.yml` file, these parameters will be automatically filled in, allowing you to create SQL as if it were a singular test. This example selects all records from the model where the specified column contains values less than one, ensuring all values are positive.

Next, we need to add this custom generic test to our schema.yml file. Here's how you can do it:

```yml
      - name: minimum_nights
        tests:
          - positive_value
```

In this example, we specify a new generic test for the minimumNights column of the dimListings model. The test we use is positiveValue.

Now, let’s see if it works. By running your dbt tests, dbt will automatically use the positiveValue macro to check that all values in the minimumNights column are positive. This demonstrates how simple and powerful custom generic tests can be in ensuring data integrity within your dbt models.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt test --select dim_listings_cleansed 

15:56:55  Running with dbt=1.7.17
15:56:55  Registered adapter: snowflake=1.7.1
15:56:55  Found 8 models, 1 seed, 1 snapshot, 9 tests, 3 sources, 0 exposures, 0 metrics, 548 macros, 0 groups, 0 semantic models
15:56:55  
15:56:57  Concurrency: 1 threads (target='dev')
15:56:57  
15:56:57  1 of 8 START test accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [RUN]
15:56:58  1 of 8 PASS accepted_values_dim_listings_cleansed_room_type__Entire_home_apt__Private_room__Shared_room__Hotel_room  [PASS in 1.25s]
15:56:58  2 of 8 START test dim_listings_minimum_nigths .................................. [RUN]
15:57:00  2 of 8 PASS dim_listings_minimum_nigths ........................................ [PASS in 1.39s]
15:57:00  3 of 8 START test no_nulls_in_dim_listings ..................................... [RUN]
15:57:01  3 of 8 PASS no_nulls_in_dim_listings ........................................... [PASS in 1.61s]
15:57:01  4 of 8 START test not_null_dim_listings_cleansed_host_id ....................... [RUN]
15:57:02  4 of 8 PASS not_null_dim_listings_cleansed_host_id ............................. [PASS in 1.22s]
15:57:02  5 of 8 START test not_null_dim_listings_cleansed_listing_id .................... [RUN]
15:57:04  5 of 8 PASS not_null_dim_listings_cleansed_listing_id .......................... [PASS in 1.33s]
15:57:04  6 of 8 START test positive_value_dim_listings_cleansed_minimum_nights .......... [RUN]
15:57:06  6 of 8 PASS positive_value_dim_listings_cleansed_minimum_nights ................ [PASS in 1.83s]
15:57:06  7 of 8 START test relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [RUN]
15:57:07  7 of 8 PASS relationships_dim_listings_cleansed_host_id__host_id__ref_dim_hosts_cleansed_  [PASS in 1.29s]
15:57:07  8 of 8 START test unique_dim_listings_cleansed_listing_id ...................... [RUN]
15:57:08  8 of 8 PASS unique_dim_listings_cleansed_listing_id ............................ [PASS in 1.24s]
15:57:08  
15:57:08  Finished running 8 tests in 0 hours 0 minutes and 12.79 seconds (12.79s).
15:57:08  
15:57:08  Completed successfully
15:57:08  
15:57:08  Done. PASS=8 WARN=0 ERROR=0 SKIP=0 TOTAL=8
```

**updated versions os packages**

DBT utils and third-party packages get updated rapidly. Please make sure that you install the latest version of dbt-utils. You can see the latest tested dbt-utils version on our GitHub page. In this source file, there is also a dbt-expectations package installed, which you can ignore for now; we will get to this later in the course.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt deps

16:00:42  Running with dbt=1.7.17
16:00:45  Installing dbt-labs/dbt_utils
16:00:46  Installed from version 1.2.0
16:00:46  Up to date!
```

When you use the latest version of dbt_utils, using the surrogate_key macro now returns an error saying there's a newer version: generate_surrogate_key.

In case you run into this error in the next lecture, please use generate_surrogate_key and it should work fine.

Also, if you use the dbt Power User VSCode extension, please quit VSCode for the time you execute dbt deps in the next lecture. Some students reported that the dbt Power User extension has a bug that breaks the dbt deps command's execution.



#### Installing Third-Party Packages

DBT (Data Build Tool) gives you the opportunity to install third-party packages into your project. Usually, you would go to [hub.getdbt.com](https://hub.getdbt.com) to look for packages, where you will see a full index of many packages.

For example, if you want to extend the core capabilities of dbt:
- To extend audit capabilities, you can use `dbt-utils`.
- For more advanced auditing, you can use `audit-helper`.
- For more sophisticated testing capabilities, you can use the `great-expectations` package, which is not necessarily hosted on dbt-hub.

Here is a step-by-step guide on how to extend the core capabilities of dbt using `dbt-utils`:

1. **Find the Package**:
    - Go to [dbt-utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) on hub.getdbt.com.
    - Locate the package definition needed for installation.

2. **Add the Package to Your Project**:
    - Copy the package definition (it's also available in your class resources).
    - Navigate to your project folder.
    - Create a new file named `packages.yml`.
    - Add the following installation definition to `packages.yml`:
      ```yaml
      packages:
        - package: dbt-labs/dbt_utils
          version: <version_number>
      ```

3. **Install the Package**:
    - To install the package, execute the following command:
      ```bash
      dbt deps
      ```
    - This command, `dbt deps`, stands for dbt dependencies. It will install the packages defined as dependencies for your project.

By following these steps, you can extend the functionality of dbt and integrate additional capabilities into your project.

We need to install it. In order to install a package, you can execute `dbt deps`. `dbt deps` stands for dbt dependencies. These packages are expressed as dependencies to your project. When you run `dbt deps`, your packages will be installed based on the package's YAML definition.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt deps

16:00:42  Running with dbt=1.7.17
16:00:45  Installing dbt-labs/dbt_utils
16:00:46  Installed from version 1.2.0
16:00:46  Up to date!
```

Let's take a look at this `dbt-utils` package. It's all available on GitHub. Here you see the public reference we add in the `packages.yaml` file. 

I want to use a specific function from this package called [surrogate_key](https://github.com/dbt-labs/dbt-utils/tree/1.2.0/#generate_surrogate_key-source) . With a `surrogate_key`, you can generate a primary key for your table. Even if you have a table that doesn't have a proper key, you can use this `surrogate_key` function and specify which columns combined will be unique. Based on this, dbt will create the key for you.

```sql
{{ dbt_utils.generate_surrogate_key(['field_a', 'field_b'[,...]]) }}
```


For example, if I go to Snowflake and take a look at the `fact_reviews` table, you will see that it doesn't have any key. It has `listing_id`, `review_date`, `reviewer_name`, `review_text`, and `review_sentiment`. Not all these columns are primary keys, but we can combine them to make a primary key.

![](/img/74.png)

Let's do this:

1. **Open the `fact_reviews` model**:
    - Navigate to your project.
    - Open the `fact_reviews` file from the `models` folder.
      ```sql
      {{
        config(
          materialized = 'incremental',
          on_schema_change = 'fail'
          )
      }}
      WITH src_reviews AS (
          SELECT * FROM {{ ref("src_reviews") }}
      )
      SELECT *
      FROM src_reviews
      WHERE review_text IS NOT NULL
      {% if is_incremental() %}
          AND review_date > (SELECT MAX(review_date) FROM {{ this }})
      {% endif %}
      ```
    - Add a new key column in the main `SELECT` statement.

2. **Add the `surrogate_key`**:
    - Add an extra column using the `surrogate_key` function.
    - Use the following columns: `listing_id`, `review_date`, `reviewer_name`, and `review_text` (excluding `review_sentiment`).
      ```sql
      SELECT
        ...,
        {{ dbt_utils.surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }} AS review_id
      FROM
        ...
      ```
      ```sql
      {{
        config(
          materialized = 'incremental',
          on_schema_change = 'sync_all_columns'
        )
      }}

      WITH src_reviews AS (
        SELECT * FROM {{ ref('src_reviews') }}
      )

      SELECT 
        {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) 
        }} AS review_id,
        *
      FROM src_reviews
      WHERE review_text IS NOT NULL
      {% if is_incremental() %}
        AND review_date > (
          SELECT MAX(review_date) 
          FROM {{ this }}
        )
      {% endif %}
      ```

3. **Refresh the Model**:
    - Execute `dbt run` to refresh the model.
    - Since this is an incremental model, add the `--full-refresh` flag:
      ```bash
      dbt run --full-refresh --select fact_reviews
      ```

Let's see if it works. 

It started an incremental run of `dev_fact_reviews`, and it's completely rebuilt. Great. 

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt run --full-refresh --select fct_reviews
18:15:19  Running with dbt=1.7.17
18:15:20  Registered adapter: snowflake=1.7.1
18:15:20  Found 8 models, 1 snapshot, 9 tests, 1 seed, 3 sources, 0 exposures, 0 metrics, 548 macros, 0 groups, 0 semantic models
18:15:20  
18:15:23  Concurrency: 1 threads (target='dev')
18:15:23  
18:15:23  1 of 1 START sql incremental model DEV.fct_reviews ............................. [RUN]
18:15:29  1 of 1 OK created sql incremental model DEV.fct_reviews ........................ [SUCCESS 1 in 6.14s]
18:15:29  
18:15:29  Finished running 1 incremental model in 0 hours 0 minutes and 8.95 seconds (8.95s).
18:15:29  
18:15:29  Completed successfully
18:15:29  
18:15:29  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

4. **Verify in Snowflake**:
    - Go to Snowflake and refresh the page.
    - Check the `dev_tables.fact_reviews` table.
    - You should now see a `review_id` column, which is a hash of all the columns that participate in the ID composition.

This process shows how simple it is to use any of the built-in packages from dbt hub or third-party providers. You can also create your own packages and distribute them publicly or internally within your organization.

![](/img/75.png)

### Learning Objectives - Documentation

**Overview**

The general concept of documentation in DBT is to keep it as close as possible to the actual source code, specifically to your analytics code. This is considered best practice when building data infrastructure. If you separate documentation into a completely standalone service, it risks diverging from your actual analytics code. To prevent this, DBT integrates documentation seamlessly with your code.

You can handle documentation in DBT in two ways. First, you can include simple documentation directly in your YAML files, such as the schema YAML where your model is defined. Here, you can add descriptions for documenting models, tables, views, columns, and so on. If more comprehensive documentation is needed, you can write it in standalone markdown files for any tables or columns. DBT will compile this documentation into an HTML service, which can be used either as a static set of HTML assets on your web server or via the built-in DBT web server for development and iterative documentation purposes.

There are two special cases to note. One is the project overview page, which has a dedicated file called overview.md. You can write the overview documentation in this markdown file. Additionally, you can configure DBT to store various assets, such as downloadable files and images, in a special folder, referencing them from the markdown files.

We will cover all these use cases and more in our upcoming lessons.

#### Writing and Exploring Basic Documentation

First, we are going to look at how to create simple documentation, generate HTML documentation based on what we define, and start the documentation survey interface. Simple documentation can be added to the YAML files for your model descriptions. You can document models, schemas, sources, macros, and tests.

Let's document our model. Please open schema.yaml and add documentation to `dim_listings_cleansed`. Adding documentation in DBT is straightforward. You simply add a new property called description and include your documentation. For example, the description for the `dim_listings_cleansed` table might state that it contains Airbnb listings `description: Cleansed table which contains Airbnb listings.`. Similarly, you can add a description tag for each column. 

```yml
(dbt_env) ➜  dbt_learn git:(main) ✗ cat models/schema.yml 

version: 2

models:
  - name: dim_listings_cleansed
    description: Cleansed table which contains Airbnb listings.
    columns:
      
      - name: listing_id
        description: Primary key for the listing
        tests:
          - unique
          - not_null
        
      - name: host_id
        description: The hosts's id. References the host table.
        tests:
          - not_null
          - relationships:
              to: ref('dim_hosts_cleansed')
              field: host_id

      - name: room_type
        description: Type of the apartment / room
        tests:
          - accepted_values:
              values: ['Entire home/apt', 'Private room', 'Shared room', 'Hotel room']

      - name: minimum_nights
        description: '{{ doc("dim_listing_cleansed_minimum_nights") }}'
        tests:
          - positive_value%   
```

For example, for the primary key of the listing, you would document the listing ID column. Let's do the same for the host ID. Copy-paste the description from the host resources: host ID is host ID. We also have room type and minimum nulls. We'll leave minimum nulls for the next lesson to add more detailed documentation.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt docs generate
18:44:03  Running with dbt=1.7.17
18:44:03  Registered adapter: snowflake=1.7.1
18:44:03  Found 8 models, 1 snapshot, 8 tests, 1 seed, 3 sources, 0 exposures, 0 metrics, 548 macros, 0 groups, 0 semantic models
18:44:03  
18:44:05  Concurrency: 1 threads (target='dev')
18:44:05  
18:44:07  Building catalog
18:44:11  Catalog written to /Users/alex/Desktop/DataEngineer_dbt_Bootcamp/dbt_learn/target/catalog.json
```

Once the basic documentation is in place, save the file. To generate the HTML website, execute dbt docs generate. DBT will process all your YAML files, compile the documentation pieces, and create an HTML page. This documentation is stored in the catalog.json file within the target folder.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cd target 
(dbt_env) ➜  target git:(main) ✗ ls -la
total 5408
drwxr-xr-x  13 alex  staff      416 Jul 15 20:44 .
drwxr-xr-x  16 alex  staff      512 Jul 15 19:55 ..
-rw-r--r--   1 alex  staff    14213 Jul 15 20:44 catalog.json
drwxr-xr-x   3 alex  staff       96 Jul 13 16:45 compiled
-rw-r--r--   1 alex  staff    20505 Jul 15 20:44 graph.gpickle
-rw-r--r--   1 alex  staff     1967 Jul 15 20:44 graph_summary.json
-rw-r--r--   1 alex  staff  1501119 Jul 15 20:44 index.html
-rw-r--r--   1 alex  staff   586624 Jul 15 20:44 manifest.json
-rw-r--r--   1 alex  staff   604338 Jul 15 20:44 partial_parse.msgpack
drwxr-xr-x   3 alex  staff       96 Jul 13 16:45 run
-rw-r--r--   1 alex  staff    13882 Jul 15 20:44 run_results.json
-rw-r--r--   1 alex  staff      234 Jul 15 20:44 semantic_manifest.json
-rw-r--r--   1 alex  staff     1065 Jul 13 21:43 sources.json
(dbt_env) ➜  target git:(main) ✗ less catalog.json 
```

You can view this structured schema definition and documentation by opening catalog.json with a code editor. This raw file isn't very human-friendly, but DBT provides an index.html and other files to create a proper HTML-based documentation. To view it, you can run a lightweight Python documentation server using dbt docs serve.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ dbt docs serve
```

For production, you might want to use a more robust server, like serving the static files behind an Nginx server. However, for our purposes, the lightweight server is sufficient. Starting the server with dbt docs serve will allow you to view the documentation in a web interface.

![](/img/76.png)

In this interface, you can explore the documentation for sources, models, macros, tests, snapshots, and third-party packages. For example, expanding the Airbnb and Dev sections will show the `dim_listings_cleansed` documentation. This includes descriptions, statistics, metadata, ownership information, package details, Snowflake relations, and column information such as types and descriptions. You can also view tests defined on the model and any referencing models. Clicking on a test shows its code and the combined code executed by Snowflake. Additionally, you can see dependencies and the model's source code, including the Jinja template and compiled code.

![](/img/77.png)

This concludes our overview of generating and serving DBT documentation. We will delve deeper into exploring these features in the next lessons.


#### Markdown-based Docs, Custom Overview Page and Assets


