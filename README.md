DBWorkLoad Demo

Overview
The goal of dbworkload is to ease the creation and execution of bespoke database workload scripts.

The user is responsible for coding the workload logic as a Python class, while dbworkload takes care of providing ancillary features, such as configuring the workload concurrency, duration and/or iteration, and more.

The user, by coding the class, has complete control of the workload flow: what transactions are executed in which order, and what statements are included in each transaction, plus what data to insert and how to generate it and manipulate it.
Database seeding
dbworkload can help with seeding a database by creating CSV files with random generated data, whose definition is supplied in a YAML file and can be extracted from a DDL SQL file.

Software requirements
dbworkload requires at least Python 3.8 and the pip utility, installed and upgraded.

dbworkload dependencies are installed automatically by the pip tool.

It has run successfully on Ubuntu 20.04+, MacOSX on both Intel and Apple silicone.

Supported DBMS drivers
psycopg (PostgreSQL, CockroachDB)
Driver documentation: Psycopg 3.

# installation
pip install dbworkload[postgres]

Step 1 - init the workload
Make sure your CockroachDB cluster is up and running.

Execute the DDL file, ad_DDL.sql, using the CockroachDB SQL client to create the database addb, and the table dly:

cockroach sql --url <<cockroachdb connection string>> --file addb_DDL.sql

Next we want to create the CSV seed files to initialize the addb.dly table:

dbworkload util csv -i addb.yaml -x 1 -d ',' --csv-max-rows 100

This will create 1 CSV file containing 100 records in the addb/ directory.

Now run the built-in Python server from the addb/ directory to serve the CSV files for import:

cd addb/
python3 -m http.server 3000

If you are running the demo on AWS/EC2, make sure to open port 3000 
If you open your browser at http://localhost:3000 you should see file dly.0_0_0.csv being served.

Using the CockroachDB SQL client, run the following query to import the CSV file:

IMPORT INTO addb.dly CSV DATA ('http://<<IP Address>>:3000/dly.0_0_0.csv') WITH delimiter = ',', nullif = '';

Step 2 - Test Queries
The following queries are defined in the addb.py file.

SELECT count(*) FROM dly WHERE isdeleted<100000;
INSERT INTO dly(user_login_id, end_customer_agreement_yr_ind) VALUES ('iam',3141);
UPDATE dly SET end_customer_agreement_yr_ind=3141 WHERE isdeleted>950000;

Step 3 - Run the workload

clear;dbworkload run -w addb.py -c 1 --uri 'postgresql://tim:8pEuq9IFNUiOCAd3bwl3AA@trs-9n3r-northamerica-q9w.aws-ca-central-1.cockroachlabs.cloud:26257/addb?sslmode=verify-full&sslrootcert=/home/tim/Library/CockroachCloud/certs/1d4d68ed-a173-461e-a522-4fbca2b062e1/trs-9n3r-northamerica-ca.crt' -d 200 -i 200
