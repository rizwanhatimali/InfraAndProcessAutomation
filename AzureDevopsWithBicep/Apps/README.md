# Apps

This folder contains sample ASP.Net Web API and ASP.Net Function app to be deployed in Azure App Service and Azure Function App respectively. Each application contains a pipeline folder which in turn use shared pipeline for applications with the application specific configuration. 

These pipelines performs the following operations:

* Creation of relevant resources in azure platform
* Build and Unit tests of Applications
* Publish code coverage for applications under Soanr Qube
* Deployment of Application into WebApp or Function App (based on _kind_ variables under common variables)