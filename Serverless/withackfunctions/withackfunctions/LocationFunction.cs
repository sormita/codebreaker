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
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace withackfunctions
{
    public static class LocationFunction
    {
        public static SqlConnection OpenConnection()
        {
            IConfigurationRoot configuration = new ConfigurationBuilder()
               .SetBasePath(Directory.GetCurrentDirectory())
               .AddJsonFile("local.settings.json", optional: false, reloadOnChange: true)
               .AddEnvironmentVariables()
               .Build();

            string connectionString = configuration["ConnectionString"];
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            return conn;
        }

        [FunctionName("GetLongLat")]
        public static async Task<HttpResponseMessage> Run(
           [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "GetLongLat/{area}/{state}")] HttpRequest req,
           string area, string state,
           ILogger log)
        {
            HttpClient _httpClient = new HttpClient();

            log.LogInformation("Function processed a request to login user.");
            var msg = $"Area: {area}, State: {state}";
            log.LogInformation(msg.ToString());

            string apikey= 
                Environment.GetEnvironmentVariable(
                    $"OpenCageAPIKey");

            var result = await _httpClient.GetAsync("https://api.opencagedata.com/geocode/v1/json?q="+area +","+state+"&key="+apikey, HttpCompletionOption.ResponseHeadersRead);
            result.EnsureSuccessStatusCode();
            var data = await result.Content.ReadAsStringAsync();

            string manipulateData = data.ToString().Replace("\"", "");
            string tempString= manipulateData.Substring(manipulateData.LastIndexOf("county"));
            string[] strActualAddress = tempString.Substring(tempString.IndexOf("county"), tempString.IndexOf("road_type")).Split(',');

            strActualAddress[0]=strActualAddress[0].Remove(strActualAddress[0].IndexOf("county:"), 7);
            strActualAddress[1]=strActualAddress[1].Remove(strActualAddress[1].IndexOf("neighbourhood:"), 14);
            strActualAddress[2]=strActualAddress[2].Remove(strActualAddress[2].IndexOf("postcode:"), 9);
            strActualAddress[3]=strActualAddress[3].Remove(strActualAddress[3].IndexOf("road:"), 5);

            using (var conn = OpenConnection())
            {
                log.LogInformation(conn.ConnectionString.ToString());
                using (SqlCommand cmd = new SqlCommand("usp_AddHungerLocation", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@County", SqlDbType.VarChar).Value = strActualAddress[0];
                    cmd.Parameters.Add("@Neighbourhood", SqlDbType.VarChar).Value = strActualAddress[1];
                    cmd.Parameters.Add("@Postcode", SqlDbType.VarChar).Value = strActualAddress[2];
                    cmd.Parameters.Add("@Road", SqlDbType.VarChar).Value = strActualAddress[3];
                    

                    int resultRows = cmd.ExecuteNonQuery();

                    return new HttpResponseMessage(HttpStatusCode.OK);
                }
            }
            
        }
    }
}
