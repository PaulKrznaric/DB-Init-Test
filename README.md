## Testing out postgresql and IAS ##
The purpose of this is for me to have an idea of what an RDS PostgreSQL server looks like and how it's managed. I want to be able to deploy it to AWS, back-up data, migrate data, and update the DB with migration scripts. 

Currently the database is deployable and destroyable via terraform to AWS. The inital setup script is not run. 

## How to Use:
This project's scripts were written on MacOS. They likely only work on the OS but may work on Linux or other Unix based machines. 
The scripts provided are written in Bash and will deploy the 

1. Navigate to /scripts/ and elevate the permissions of `setup` (`chmod +x setup`)  
2. Run the script (./setup)  
  a. Note: This will automatically apply terraform under an account called `emr-dev` under your terraform configuration
3. When you are done with your database, in the same directory run the teardown (`./teardown)*

* If you do not destroy your database it will run indefinitely on AWS and you'll have to pay for it. 
