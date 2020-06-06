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
using System.Data;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using Microsoft.WindowsAzure.Storage.Blob.Protocol;

namespace withackfunctions
{
    public static class UserLogin
    {
        public static SqlConnection OpenConnection()
        {
            IConfigurationRoot configuration = new ConfigurationBuilder()
               .SetBasePath(Directory.GetCurrentDirectory())
               //.AddJsonFile("local.settings.json", optional: false, reloadOnChange: true)
               .AddEnvironmentVariables()
               .Build();

            string connectionString = configuration["ConnectionString"];
            SqlConnection conn = new SqlConnection(connectionString);            
            conn.Open();
            return conn;
        }

        [FunctionName("UserLogin")]        
        public static async Task<HttpResponseMessage> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "UserLogin/{username}/{password}")] HttpRequest req,
            string username, string password,
            ILogger log)
        {            
            log.LogInformation("Function processed a request to login user.");
            var msg = $"User name: {username}, Password: {password}";
            log.LogInformation(msg.ToString());

            using (var conn = OpenConnection())
            {
                log.LogInformation(conn.ConnectionString.ToString());
                using (SqlCommand cmd = new SqlCommand("usp_UserLoginProcedure", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@Username", SqlDbType.VarChar).Value = username;
                    cmd.Parameters.Add("@Password", SqlDbType.VarChar).Value = password;
                    //var userid = cmd.Parameters.Add("@UserID", SqlDbType.Int);
                    //userid.Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = cmd.ExecuteReader();

                    User usr = new User();

                    while (reader.Read())
                    {                        
                        usr.UserID = int.Parse(reader["UserID"].ToString());
                        usr.Username = reader["Username"].ToString();                        
                    }

                    var result = JsonConvert.SerializeObject(usr);

                    return new HttpResponseMessage(HttpStatusCode.OK)
                    {
                        Content = new StringContent(result, Encoding.UTF8, "application/json")
                    };
                }
            }
        }

        
    }

    [Serializable]
    public class User
    {
        public string Username { get; set; }
        public int UserID { get; set; }
    }
    
}
