# AWS Deployment Demo Project

This project demonstrates how to deploy a serverless application using AWS, utilizing Lambda functions, an RDS MySQL database, and an S3-hosted front-end. It includes an API to fetch car models by make and a simple front-end to interact with the API.


## Features

- **Serverless Framework**: Easily deploy and manage AWS Lambda functions.
- **RDS MySQL Database**: Stores information about car makes and models.
- **S3 Front-End Hosting**: Provides a basic web interface to interact with the API.
- **Scalable Architecture**: Utilizes AWS resources like VPC, subnets, and security groups for secure and scalable deployments.


## Setup Guide

### Prerequisites

#### 1. VSCode Dev Container (preferred method)

This is an entirely-contained project with setup scripts that automatically install all required packages and perform necessary environment configurations. This does not affect your local machine - it is all executed inside of a Docker container.

1. Download and install [Docker Desktop](https://www.docker.com/)

2. Install VSCode [Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension

#### 2. Local

It is not recommended to run this project outside of a Dev Container due to machine-specific constraints. You may find that certain scripts don't work. You will also need to manually configure a local database.


## Installation

* Docker Desktop: https://www.docker.com/products/docker-desktop/

* Git: https://git-scm.com/downloads

* VSCode: https://code.visualstudio.com/download

* VSCode Dev Containers: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

><b>ⓘ</b>&nbsp;&nbsp;
>NodeJS is not technically required for this project because it will be installed within the Dev Container so that the version is always correctly maintained for the project

><b>⚠</b>&nbsp;&nbsp;
>Due to the current functionality of VSCode Dev Containers, do not directly clone this repository as you normally would. Doing so will result in sluggish performance due to sharing data across file systems. Instead, follow the steps below:

1. Ensure Docker is up and running

2. Open the command palette within any instance of VSCode: `⌘/Ctrl + ⇧/Shift + P` → <i>Dev Containers: Clone Repository in Container Volume</i>

3. Paste in `https://github.com/srm985/aws-deployment-demo.git`

4. The project will open in a new VSCode window. Opening the first time may take some time as the project is provisioning the Docker volume and workspace.

5. Drop the `.env` file into the root directory of the project. Ensure it's named correctly as sometimes downloading it can drop the leading dot.

6. Get started developing! 🚀 There's no need to even run `npm install` or perform any sort of updates.


## Local Development

Ensure your `index.html` is configured correctly with the localhost `BASE_URL` and then run:
```sh
npm start
```

You can access the endpoints at [http://localhost:3100/local/alive](http://localhost:3100/local/alive)

You can access the front end at [http://localhost:8080/index.html](http://localhost:8080/index.html)


## Deployment

1. Deploy the application:
   ```sh
   npm run deploy
   ```

2. Access the front-end:
   - Upload the `index.html` file to the S3 bucket created by the deployment.
   - Access the bucket's public URL.


## Usage

1. **API Endpoints**:
   - **Status Check**:
     - `GET /alive`
     - Response: `{ "isAlive": true }`
   - **Fetch Car Models**:
     - `GET /cars/{make}/models`
     - Response: `{ "modelsList": [{ "model": "3 Series" }, ...] }`

2. **Front-End**:
   - Open the hosted `index.html` in a browser.
   - Check the server status using the *Check status* button.
   - Search for car models by entering a make and clicking *Search*.


## Insights

#### Serverless Configuration

- The `serverless.yml` file defines AWS resources, including:
  - **Lambda Functions**: For API endpoints.
  - **RDS Database**: A MySQL instance with VPC and security group configurations.
  - **S3 Bucket**: For hosting the front-end.

- **Plugins**:
  - `serverless-offline`: Local development support.
  - `serverless-prune-plugin`: Removes old Lambda versions to save storage.

#### Front-End

- The front-end interacts with the API via `fetch()` calls.
- Dynamically updates the DOM with API responses.

#### Database

- The MySQL database contains a table `cars` with pre-populated data.
- The `get-models` Lambda queries the database using environment variables for secure configuration.

## Serverless Configuration Breakdown

This section explains the purpose and functionality of each part of the `serverless.yml` file, which defines the settings and resources for the Serverless Framework deployment.

### `service: aws-deployment-demo`

- **Service Name**: Defines the name of the service (project) you are deploying. In this case, it's named `aws-deployment-demo`.

---

### `package:`

This section specifies how the service should be packaged before deployment.

- **individually**: When set to `true`, this option packages each function individually, which helps in reducing the package size and making deployments more efficient.

---

### `provider:`

This section defines the cloud provider and other provider-specific configurations.

- **name**: The cloud provider to use. In this case, it's set to `aws`, meaning the project will be deployed on AWS Lambda.
- **runtime**: Specifies the runtime environment for the Lambda functions. In this case, it's set to `nodejs20.x`, which means the functions will run on Node.js version 20.
- **region**: Defines the AWS region for the deployment. In this case, it's set to `us-east-1`.
- **stage**: Defines the deployment stage, which can be different for each environment (e.g., `local`, `dev`, `prod`). It defaults to `local` if not specified.
- **timeout**: Specifies the timeout for Lambda functions in seconds. Here, it's set to `30` seconds.
- **vpc**: Configures the VPC settings for the Lambda functions. This ensures that the Lambda functions have the required network access (e.g., access to a MySQL database).
  - **securityGroupIds**: The security group that the Lambda functions will use to communicate with other services, such as the RDS database.
  - **subnetIds**: Defines the subnets in the VPC that the Lambda functions will run in.

- **environment**: Defines environment variables that are injected into Lambda functions at runtime.
  - **ALLOWED_ORIGINS**: Specifies the allowed origins for CORS (Cross-Origin Resource Sharing).
  - **NODE_ENV**: Defines the Node environment (e.g., development, production).
  - **DATABASE_* variables**: Environment variables related to connecting to the MySQL database, including database address, username, password, and port.

---

### `plugins:`

This section lists the plugins used by the Serverless Framework.

- **serverless-offline-ssm**: A plugin that allows local usage of AWS Systems Manager (SSM) parameters, which is useful for local testing of environment variables stored in AWS.
- **serverless-offline**: Enables local emulation of AWS Lambda and API Gateway, allowing testing of your functions locally.
- **serverless-prune-plugin**: Prunes (removes) old versions of deployed Lambda functions to save storage and keep the deployment environment clean.

---

### `custom:`

This section defines custom configurations for plugins.

- **serverless-offline**: Custom configuration for the `serverless-offline` plugin.
  - **httpPort**: The port on which the local HTTP server will run (for the API).
  - **lambdaPort**: The port used for invoking Lambda functions locally.
  - **reloadHandler**: When set to `true`, it reloads the handler on changes to enable faster development.

- **serverless-offline-ssm**: Custom configuration for the `serverless-offline-ssm` plugin.
  - **stages**: Specifies which stages (e.g., `local`) will use the `serverless-offline-ssm` plugin for local testing.

- **prune**: Configuration for the `serverless-prune-plugin`.
  - **automatic**: When set to `true`, the plugin will automatically prune old versions of the Lambda functions.
  - **number**: Defines the number of versions to keep for each function. Older versions are automatically deleted beyond this number.

---

### `resources:`

This section defines additional AWS resources that are not part of the Lambda functions but are required for the application.

- **MyDatabase**: An RDS MySQL database instance.
  - **DBInstanceIdentifier**: The unique identifier for the RDS instance.
  - **AllocatedStorage**: The storage size for the database in GB.
  - **DBInstanceClass**: The instance type for the database. In this case, it’s set to `db.t3.micro`, which is a small, cost-effective instance type.
  - **Engine**: The database engine to use (MySQL in this case).
  - **EngineVersion**: The version of MySQL to use (version `8.0`).
  - **MasterUsername** and **MasterUserPassword**: The username and password for the database’s master account.
  - **PubliclyAccessible**: Specifies whether the database should be publicly accessible. It’s set to `true` for this example, but should be set to `false` for production environments.
  - **VPCSecurityGroups**: The security group to use for the database, allowing Lambda functions to access it.
  - **DBSubnetGroupName**: Specifies the subnet group in which the database will be placed.

- **DBSubnetGroup**: Defines the subnet group for the database, ensuring the database has proper networking.

- **Subnet1** and **Subnet2**: Defines the subnets within the VPC that the Lambda functions and RDS instance will use. These subnets are placed in different availability zones (`us-east-1a` and `us-east-1b`) for redundancy.

- **VPC**: Defines the Virtual Private Cloud (VPC) in which the Lambda functions and RDS instance will reside.
  - **CidrBlock**: Defines the IP address range for the VPC (`10.0.0.0/16`).
  - **EnableDnsSupport** and **EnableDnsHostnames**: Ensures the VPC supports DNS resolution and hostnames.

- **InternetGateway** and **VPCGatewayAttachment**: Define an Internet Gateway and attach it to the VPC to enable internet access for the resources.

- **PublicRouteTable** and **PublicRoute**: Define routing for traffic from the subnets to the internet via the Internet Gateway.

- **LambdaSecurityGroup**: Defines the security group for Lambda functions, allowing them to communicate with the RDS MySQL database.
  - **SecurityGroupIngress**: Configures inbound rules for the security group, allowing TCP connections on port 3306 (MySQL).

- **AWSDeploymentDemo**: Defines an S3 bucket to store static assets such as the front-end `index.html` file.

---

### `functions:`

This section defines the Lambda functions, their handlers, and events (such as API Gateway routes).

- **alive**: A simple Lambda function that returns the server status (alive or dead).
  - **handler**: Points to the `default` export in the `functions/alive.js` file.
  - **events**: Defines the event that triggers the Lambda. In this case, an HTTP GET request to the `/alive` path.
  - **cors**: Configures Cross-Origin Resource Sharing (CORS) to allow all origins (`*`).

- **get-models**: A Lambda function that returns car models for a given make.
  - **handler**: Points to the `default` export in the `functions/get-models.js` file.
  - **environment**: Defines environment variables needed for the function to access the database.
  - **events**: Defines the event that triggers the Lambda. In this case, an HTTP GET request to the `/cars/{make}/models` path.
  - **cors**: Configures CORS for the endpoint, allowing all origins (`*`).


## Troubleshooting

- **Lambda Access**: Ensure the Lambda function has the correct security group to access the database.
- **CORS Issues**: Verify `ALLOWED_ORIGINS` is correctly set.
- **Database Connection**: Confirm that database credentials and endpoint are correct.
