using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net;
using System.Web;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.Extensions.Options;
using Microsoft.WindowsAzure.Storage.Auth;
using System.Text;

namespace withackfunctions
{
    public static class BlobUpload
    {

        [FunctionName("BlobUpload")]
        public static async Task<HttpResponseMessage> Run(
           [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequestMessage req,
           ILogger log)
        {
            log.LogInformation("Function processed a request to upload blob.");

            AzureStorageBlobOptions _azureStorageBlobOptions = new AzureStorageBlobOptions();
            AzureStorageBlobOptionsTokenGenerator _azureStorageBlobOptionsTokenGenerator = new AzureStorageBlobOptionsTokenGenerator();

            string contentType = req.Content.Headers?.ContentType?.MediaType;
            log.LogInformation("contentType : " + req.Content.IsMimeMultipartContent());

            string blobname = Guid.NewGuid().ToString("n");
            log.LogInformation("Name" + blobname);

            var body = await req.Content.ReadAsStringAsync();


            var sasToken =
            _azureStorageBlobOptionsTokenGenerator.GenerateSasToken(
                _azureStorageBlobOptions.FilePath);

            var storageCredentials =
            new StorageCredentials(
                sasToken);

            var cloudStorageAccount =
            new CloudStorageAccount(storageCredentials, _azureStorageBlobOptions.AccountName, null, true);

            var cloudBlobClient =
                cloudStorageAccount.CreateCloudBlobClient();

            var cloudBlobContainer =
                cloudBlobClient.GetContainerReference(
                    _azureStorageBlobOptions.FilePath);

            //var blobName =
            //$"{Guid.NewGuid()}{Path.GetExtension(fileInfo.FileName)}";

            //blobName = blobName.Replace("\"", "");
            var cloudBlockBlob =
            cloudBlobContainer.GetBlockBlobReference(blobname);
            cloudBlockBlob.Properties.ContentType = "text/csv";

            using (Stream stream = new MemoryStream(Encoding.UTF8.GetBytes(body)))
            {
                log.LogInformation("streaming : ");
                await cloudBlockBlob.UploadFromStreamAsync(stream);
            }

            return req.CreateResponse(HttpStatusCode.OK, "Doc Uploaded Successfully");
        }
    }

    public class AzureStorageBlobOptions
    {
        public string AccountName { get; set; }
        public string FilePath { get; set; }
        public string ConnectionString { get; set; }

        public AzureStorageBlobOptions()
        {
            this.AccountName =
                Environment.GetEnvironmentVariable(
                    $"{nameof(AzureStorageBlobOptions)}:AccountName");
            this.ConnectionString =
                Environment.GetEnvironmentVariable(
                    $"{nameof(AzureStorageBlobOptions)}:ConnectionString");
            this.FilePath =
                Environment.GetEnvironmentVariable(
                    $"{nameof(AzureStorageBlobOptions)}:FilePath");
        }
    }

    public class AzureStorageBlobOptionsTokenGenerator
    {        

        public string GenerateSasToken(
            string containerName)
        {
            return this.GenerateSasToken(
                containerName,
                DateTime.UtcNow.AddSeconds(30));
        }

        public string GenerateSasToken(
            string containerName,
            DateTime expiresOn)
        {
            IConfigurationRoot configuration = new ConfigurationBuilder()
               .SetBasePath(Directory.GetCurrentDirectory())
               //.AddJsonFile("local.settings.json", optional: false, reloadOnChange: true)
               .AddEnvironmentVariables()
               .Build();

            string connectionString = configuration["AzureStorageBlobConnectionString"];

            var cloudStorageAccount =
                CloudStorageAccount.Parse(connectionString);
            var cloudBlobClient =
                cloudStorageAccount.CreateCloudBlobClient();
            var cloudBlobContainer =
                cloudBlobClient.GetContainerReference(containerName);

            var permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write;

            string sasContainerToken;

            var shareAccessBlobPolicy =
                new SharedAccessBlobPolicy()
                {
                    SharedAccessStartTime = DateTime.UtcNow.AddMinutes(-5),
                    SharedAccessExpiryTime = expiresOn,
                    Permissions = permissions
                };

            sasContainerToken =
                cloudBlobContainer.GetSharedAccessSignature(shareAccessBlobPolicy, null);

            return sasContainerToken;
        }
    }
}
