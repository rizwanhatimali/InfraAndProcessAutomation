# Azure Agents

To build and deploy your code using Azure Pipelines, you need at least one agent. An agent is a service that runs the jobs defined in your pipeline. The execution of these jobs can occur directly on the agent's host machine or in containers.

This folder contains scripts to create azure agents which will run as containers in Azure Container Instances and can be used to execute jobs in CICD pipelines.

__Helper__ subfolder which contains shell scripts to be used to install environment, OS and tools.

__Installer__ folder contains a powershell script to install require powershell modules and shell scripts to create the environment to run the application.

The _yaml_ files __azure-agent-pipelines.yml__ and __azure-image-pipelines.yml__ will be used to create CI and CD pipelines to deploy Azure agent into container instances in azure. The services used in container are mentioned in __docker-compose.yml__ file and the commands used to create container image is specified in __DockerFile__.
