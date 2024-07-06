# [dbt](https://www.getdbt.com/)

- **Purpose**: dbt is a tool for transforming data within a data warehouse.
- **Functionality**: It allows data analysts and engineers to write data transformation code in SQL. It also manages dependencies between transformations and provides documentation and testing capabilities.
- **Role in Pipeline**: dbt handles the transformation layer, ensuring that raw data is converted into meaningful, usable formats.

---
OBJECTIVES of this  
* Data-maturity model
* dbt and data architectures
* Data warehouses, data lakes, and lakehouses
* ETL and ELT procedures
* dbt fundamentals
* Analytics Engineering


![](/img/1.png)

**ETL**
![](/img/02.png)

**ELT**
So the world has changed, as you know, of storage costs like two cents these days for every one GB of data. So it was logical to reorganize the traditional ETL workflow.
![](/img/03.png)
Data warehouses like Snowflake Redshift and BigQuery are extremely scalable and performant, so it makes sense to do two transformations inside the database rather than external processing layer.

**Data Warehouse**
storing structured data
![](/img/04.png)
Typically, you interact with the data warehouse by executing SQL against it. So data warehouses is nothing more than a performance engine that lets us do analytics workloads on our data using sequel. 

**External Tables**
First of all, you pay for the compute nodes, whether they are used or they are not used. And we are not talking about lethal amounts here. In case you have large datasets, that's very pricey. Even if you're a data warehouse. Storage is underutilized as you have small amounts of data, but it requires high analytical workloads.

Second, you can set up auto scaling, but it does that does not necessarily mean you can scale to meet your peak workloads.

There is this concept called external tables.
![](/img/06.png)
![](/img/07.png)
We have the option to store large files outside of the data warehouse in, for example, Amazon S3 or blob storage. So we can decouple the compute component from the storage component. At this point, we can scale the compute and the storage independently from the data that warehousing the istances.

So now we handle the storage and compute for structured data, but what do we do in case we have unstructured data like images and video videos or text files? Data Lake.

**Data Lake**
unstructured or send structured
![](/img/05.png)
You can think of a data lake as a repository where you can put all kinds of data ranging from Rome cleanest, unstructured, semi-structured and so on. It is like a very scalable fire system on premise, this will be called GFS or Hadoop distributed file system, but for cloud. There are others like Amazon S3 or Asia. Is your data lake storage Gen2 a.k.a. address to. 

The point of the data lake is to store files so they have no computer integrated. This means that if you're analytical, workloads increase. You can scale your compute instances independently from storage and your cloud provider will take care of handling external tables itself. If you use `Databricks` or `Snowflake`, these providers will store your data in the data lake by default. And they will only provide you with analytical clusters that you can set up the way you want.

**Data Lakehouse**

Emerged due to the limitations of data lakes. 
![](/img/08.png)
It essentially combines the best features of data lakes and data warehouses. In the case of a lake house, we have very similar data structure and data management features that we have in our data warehouse. However, it sits on top of a low cost cloud storage.  What's great in a lake houses is the cost efficient storage provided by your cloud provider. Also, the acid transactional support so you can ensure consistency and that the scheme of the data is stored in a Lake House metal store. Additionally, you can evolve the schema of your tables without having to make a copy of the dataset. As for governance, you can control and authorize access to your data, and we'll get an interface with which you can connect to visitors to the Lake House. 

**ETL process**
The transformations and normalization typically happened in the staging area before the load of the application of the data or the cleansing of the data were performed. As storage prices were high.
![](/img/09.png)


**ELT process**
![](/img/10.png)
We are now able to shift away from the ETL, extract, transform load data integration, transition of processes to extract loads, transform for easy,

**Modern data Stack in the AI Era**
![](/img/11.png)
Fivetran and Stitch are one of the most popular extracts and those tools that we have available today. The transformation layer sits on top of a cloud data warehouse and it uses DVT. You have Looker as a BI tool, for example, and sensors for reverse ETL. 

Now, the modern data stack is structured differently than traditional legacy tools. For example, in a traditional data stack, your BI tool would not only handle visualizations but also act as a data warehouse with integrated storage. So, you would have done everything within your BI tool. These tools were massive and complicated. They were vertically integrated since they included storage within the data warehouse, and you performed visualizations in them as well. However, the modern data stack really flattens this out. It is a horizontally integrated set of tools that are fully managed, cloud-based, and both cheap and easy to use. Because corporations realize that data is a product in itself, we now see that DevOps tools are evolving. Not just tools but also practices are becoming part of this modern data stack space and are gaining a lot of popularity. Today, we perform data engineering and analytics engineering, which follow software engineering and DevOps best practices.

The modern data stack is essentially the productionization of the different layers of the data integration flow. DBT (Data Build Tool) plays a key role in this by enabling teams to perform data transformations inside the data warehouse. The creators of DBT developed it as a tool to streamline and standardize the transformation process, making it more efficient and integrated within the data workflow.
 
**slowly changing dimensions**

