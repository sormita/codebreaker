# codebreaker
COVID-19 Food Crisis Viable Solution with AI and Analytics

Using analytics data and AI for food crisis management lets you respond both proactively and reactively to the hunger crisis gripping the entire country.
Though there is a huge population that is in dire need of food supplies, there is a group of philanthropists, NGO’s and Government initiated programs who want to reach out to them to fulfil their demands.
It is important to do that systematically to ensure there is less wastage and everyone can have their share. Also it is important to address the distress calls especially from business entities like migrant workers.

We have built this application to provide a viable solution to the above problem. 
![Architecture](https://github.com/sormita/codebreaker/blob/5b700e2a21cdae63bdc3c09ffe951a2c9aa54e8f/Documents/ArchitectureDiagram3%20(1).png)

Currently we have built this application based on data for the state of Karnataka. 
There are 2 flows. There are 2 types of users:
1.	Registered users
2.	Ad-hoc users
The registered user navigates to the site and logs in. Following are the types of registered users:
Food Demand users:
1.	Government Hospitals
2.	Quarantine Centers
3.	NGOs operating in slum areas
Food Supply users:
1.	Ration shops
2.	Charity houses
After the registered users login, they will upload food demand/supply data in the application based on which analytics will be performed.
There are Ad-Hoc users, who can directly place their demand for food via chatbot. There can be Ad-Hoc donors also, who might want to donate for some people for a particular day.
Analytics done in the tool are as follows:
Forecast Accuaracy dashboard (for the state of Karnataka) food crisis management contains below reports.

Dashboard Landing Page:
![Architecture](https://github.com/sormita/codebreaker/blob/5b700e2a21cdae63bdc3c09ffe951a2c9aa54e8f/Documents/Dashboard1.png)
1. Next Week Demand Gauge KPI shows the demand range with different threshold. Green indicates demand Fulfilled, orange indicates we can arrange and Red indicates High demands.
2. Supply Vs Demand Line Graph represents the forecast supply and demand over next 21 days(3 weeks) period of time
3. Donut charts indicates the percentage of food supply, wastage and shortage in different centers like hospital, Quarantine center and Villages.

District wise supply and supplier details:
![Architecture](https://github.com/sormita/codebreaker/blob/5b700e2a21cdae63bdc3c09ffe951a2c9aa54e8f/Documents/Dashboard2.png)
1. District-wise Matrix chart elaborates the detailed data of wastage and shortage with drill down from district-->area-->Center name with Date drill down from Year--> Quarter -->Month-->Date.
2. Karanataka Map chart gives a provision to navigate and explore all the district suppliers in with their location and the amount of food they can provide.
Map has zoom-in and zoom-out feature with routes.

The application also comes in with Watson Assistant chatbot which can be further extended to identify distress call/donor calls.

Built With:
Angular 8 -> Used to build the front end web application
.Net Core -> Used to code the serverless functions
Azure Storage -> Used to save the data upload files
Azure Data Factory -> Used to upload the data from csv files to Azure SQL Server
SQL Server -> Used as the database
IBM Watson Assistant -> Used as chatbot 
PowerBI -> Used for analytics

Solution Roadmap:
![Architecture](https://github.com/sormita/codebreaker/blob/master/Documents/SolutionRoadmap.PNG)

Deployed application link:
https://withackfooddemandsupply.azurewebsites.net/

