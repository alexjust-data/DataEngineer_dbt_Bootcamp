# [dbt™ (Data Build Tool) ](https://www.getdbt.com/)
---

1. [Introduction]()  
2. [Modern data Stack in the AI Era]()  
3. [slowly changing dimensions SCD]()  
4. [dbt™ Overview]()
5. [PROJECT OVERVIEW (Analytics Engineering with Airbnb)]()
   1. [resources]()
   2. [snowflake]()
   3. [dbt setup]()
   4. [VSC extension]() : `vscode-dbt-power-user`

---
### Introduction

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

### PROJECT OVERVIEW (Analytics Engineering with Airbnb)

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
 
#### resources

* [single markdown file](https://github.com/nordquant/complete-dbt-bootcamp-zero-to-hero/blob/main/_course_resources/course-resources.md)
* [dbt project's GitHub page](https://github.com/nordquant/complete-dbt-bootcamp-zero-to-hero)


#### snowflake 👉🏻 [link](https://signup.snowflake.com/?utm_cta=trial-en-www-homepage-top-right-nav-ss-evg&_ga=2.74406678.547897382.1657561304-1006975775.1656432605&_gac=1.254279162.1656541671.Cj0KCQjw8O-VBhCpARIsACMvVLPE7vSFoPt6gqlowxPDlHT6waZ2_Kd3-4926XLVs0QvlzvTvIKg7pgaAqd2EALw_wcB)

* SnoeFow edition : Standard
* Provider : AWS Web Service
* Place : Ohio

Send you a link: https://boryss-qp53113.snowflakecomputing.com/console/login?activationToken=

Here we are at the Snowflake master user registration page. You see, this is the one which is some random string and the US is to dot IWC. `borysxs-qp53113.`

**Set up dbt's permissions in Snowflake and import our datasets**

Snowflake :
* `+ create : SQL WorkSheet`

![](img/18.png)

**Snowflake user creation**
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

**Snowflake data import**

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

#### dbt setup

First, you will need to create a DBT configuration folder. The idea is that you got to have a dot DB folder in your home folder.


You have the information here:


```sql
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
(dbt_env) ➜  DataEngineer_dbt_Bootcamp git:(main) ✗ ls -la
total 56
drwxr-xr-x@  9 alex  staff    288 Jul  8 19:19 .
drwx------@ 28 alex  staff    896 Jul  8 18:42 ..
drwxr-xr-x  12 alex  staff    384 Jul  7 10:41 .git
-rw-r--r--   1 alex  staff    150 Jul  8 19:20 .gitignore
-rw-r--r--   1 alex  staff  23479 Jul  8 18:35 README.md
drwxr-xr-x   6 alex  staff    192 Jul  8 18:57 dbt_env
drwxr-xr-x  11 alex  staff    352 Jul  8 19:14 dbt_learn
drwxr-xr-x  21 alex  staff    672 Jul  8 18:47 img
drwxr-xr-x   3 alex  staff     96 Jul  8 19:15 logs
```

`dbt debug` Makes a connection to your database, and it also checks some of the configuration files and it just, so let's execute DB to debug.

```sh
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
(dbt_env) ➜  dbt_learn git:(main) ✗ ls -la
total 24
drwxr-xr-x  12 alex  staff   384 Jul  8 19:34 .
drwxr-xr-x@  9 alex  staff   288 Jul  8 19:19 ..
-rw-r--r--   1 alex  staff    29 Jul  8 19:14 .gitignore
-rw-r--r--   1 alex  staff   571 Jul  8 19:14 README.md
drwxr-xr-x   3 alex  staff    96 Jul  8 19:14 analyses
-rw-r--r--   1 alex  staff  1241 Jul  8 19:19 dbt_project.yml
drwxr-xr-x   3 alex  staff    96 Jul  8 19:34 logs
drwxr-xr-x   3 alex  staff    96 Jul  8 19:14 macros
drwxr-xr-x   3 alex  staff    96 Jul  8 19:14 models
drwxr-xr-x   3 alex  staff    96 Jul  8 19:14 seeds
drwxr-xr-x   3 alex  staff    96 Jul  8 19:14 snapshots
drwxr-xr-x   3 alex  staff    96 Jul  8 19:14 tests
```

``dbt_project.yml` is our global configuration for this project. So these are standard project level configurations and here are our model level configuration.

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

If you take a more if you take a look at the model, you see we have some example in water set up here by default. So we like to ask you to delete the example for to just get in the folder itself.

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ ls -la models
total 0
drwxr-xr-x   3 alex  staff   96 Jul  8 19:14 .
drwxr-xr-x  12 alex  staff  384 Jul  8 19:34 ..
drwxr-xr-x   5 alex  staff  160 Jul  8 19:14 example
(dbt_env) ➜  dbt_learn git:(main) ✗ rm -r models/example
```

#### VSC extension : [vscode-dbt-power-user](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user)

![](img/21.png)

![](img/22.png)

![](img/23.png)

![](img/24.png)

When you are creating a new dbt project and you don't have a `packages.yml `file nor know what dependencies you might need, you can start with an empty packages.yml file. Then, as you develop your project and discover which additional packages might be useful, you can add those dependencies to the file.

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

```sh
(dbt_env) ➜  dbt_learn git:(main) ✗ cat packages.yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.2.0
```

![](img/26.png)


#### Data Flow - Overview

