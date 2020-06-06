using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net;
using System.Text;

namespace withackfunctions
{
    public static class Function1
    {
        
        [FunctionName("CovidSummary")]
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            HttpClient _httpClient=new HttpClient();
            log.LogInformation("Function processed a request to get covid summary.");

            //string name = req.Query["name"];

            //string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            //dynamic data = JsonConvert.DeserializeObject(requestBody);
            //name = name ?? data?.name;

            var result= await _httpClient.GetAsync("https://api.covid19api.com/summary", HttpCompletionOption.ResponseHeadersRead);
            result.EnsureSuccessStatusCode();
            var data = await result.Content.ReadAsStringAsync();

            return new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(data, Encoding.UTF8, "application/json")
                };
        
        }
    }
}
