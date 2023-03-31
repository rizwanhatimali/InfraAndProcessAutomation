# To Automate Infrastructure creation, intergration and deployment processes of Application development

This repository contains the generic scripts designed to create pipelines to automate below application development activities:

* ### Continuous Integration: ###

    Continuous integration (CI) is the practice of automating the integration of code changes from multiple contributors into a single software project. It’s a primary DevOps best practice, allowing developers to frequently merge code changes into a central repository where builds and tests then run. Automated tools are used to assert the new code’s correctness before integration.
    
    This repository contains scripts to create CI pipelines (tested with Azure Devops) which includes build, unit test and publish code coverage for sample .Net applications as well as pipelines to integrate IAC (Infrastructure as code) scripts.
----

* ### Continuous Deployment: ###

    Continuous deployment (CD) is a software release process that uses automated testing to validate if changes to a codebase are correct and stable for immediate autonomous deployment to a production environment.

    This repository contains scripts to create CD pipelines (tested with Azure Devops) to deploy sample .Net Applications to App Services or Functions hosted on Azure cloud platform as well as to execute IAC scripts to deploy complete environment and resources to run the applications on Azure platform.

----

* ### Infrastructure Creation: ###

    This repository contains PowerShell and biceps scripts to create various Azure services as well as yaml scripts to create CD pipelines to automate creation of individual resources as well as whole dev, qa and prod environment as per specific application requirement.

