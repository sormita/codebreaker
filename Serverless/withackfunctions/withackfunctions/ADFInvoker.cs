using System;
using System.IO;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Management.DataFactory;
using Microsoft.Azure.Management.DataFactory.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace withackfunctions
{
    public static class ADFInvoker
    {
        [FunctionName("ADFInvoker")]
        public static async System.Threading.Tasks.Task<IActionResult> RunAsync([BlobTrigger("witdatauploadblob/{name}", Connection = "AzureStorageBlobConnectionString")]Stream myBlob, string name, ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");


            string tenantId = Environment.GetEnvironmentVariable($"tenantId"); 
            string applicationId = Environment.GetEnvironmentVariable($"applicationId");
            string authenticationKey = Environment.GetEnvironmentVariable($"authenticationKey");
            string subscriptionId = Environment.GetEnvironmentVariable($"subscriptionId");
            string resourceGroup = Environment.GetEnvironmentVariable($"resourceGroup");
            string factoryName = Environment.GetEnvironmentVariable($"factoryName");
            string pipelineName = Environment.GetEnvironmentVariable($"pipelineName");

            //Check body for values
            if (
                tenantId == null ||
                applicationId == null ||
                authenticationKey == null ||
                subscriptionId == null ||
                factoryName == null ||
                pipelineName == null
                )
            {
                return new BadRequestObjectResult("Invalid request body, value missing.");
            }

            //Create a data factory management client
            var context = new AuthenticationContext("https://login.windows.net/" + tenantId);
            ClientCredential cc = new ClientCredential(applicationId, authenticationKey);
            AuthenticationResult result = context.AcquireTokenAsync("https://management.azure.com/", cc).Result;
            ServiceClientCredentials cred = new TokenCredentials(result.AccessToken);
            var client = new DataFactoryManagementClient(cred)
            {
                SubscriptionId = subscriptionId
            };

            //Run pipeline
            CreateRunResponse runResponse;
            PipelineRun pipelineRun;

            log.LogInformation("Called pipeline");

            runResponse = client.Pipelines.CreateRunWithHttpMessagesAsync(
                    resourceGroup, factoryName, pipelineName).Result.Body;

            log.LogInformation("Pipeline run ID: " + runResponse.RunId);

            //Wait and check for pipeline result
            log.LogInformation("Checking pipeline run status...");
            while (true)
            {
                pipelineRun = client.PipelineRuns.Get(
                    resourceGroup, factoryName, runResponse.RunId);

                log.LogInformation("Status: " + pipelineRun.Status);

                if (pipelineRun.Status == "InProgress" || pipelineRun.Status == "Queued")
                    System.Threading.Thread.Sleep(15000);
                else
                    break;
            }

            //Final return detail
            string outputString = "{ \"PipelineName\": \"" + pipelineName + "\", \"RunIdUsed\": \"" + pipelineRun.RunId + "\", \"Status\": \"" + pipelineRun.Status + "\" }";
            JObject outputJson = JObject.Parse(outputString);
            return new OkObjectResult(outputJson);
        }
    }
}
