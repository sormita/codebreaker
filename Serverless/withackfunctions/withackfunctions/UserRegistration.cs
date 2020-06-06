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
using System.Data;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;

namespace withackfunctions
{
    public static class UserRegistration
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

        [FunctionName("UserRegistration")]
        public static async Task<HttpResponseMessage> Run(
           [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)] HttpRequest req,
           ILogger log)
        {
            log.LogInformation("Function processed a request to register user.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            UserRegistrationEntity usrRegister = JsonConvert.DeserializeObject<UserRegistrationEntity>(requestBody);

            log.LogInformation("name:" + usrRegister.Username);

            using (var conn = OpenConnection())
            {
                log.LogInformation(conn.ConnectionString.ToString());
                using (SqlCommand cmd = new SqlCommand("usp_AddUserRegistration", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@Username", SqlDbType.VarChar).Value = usrRegister.Username;
                    cmd.Parameters.Add("@Password", SqlDbType.VarChar).Value = usrRegister.Password;
                    cmd.Parameters.Add("@EntityType", SqlDbType.VarChar).Value = usrRegister.EntityType;
                    cmd.Parameters.Add("@foodEntityType", SqlDbType.VarChar).Value = usrRegister.foodEntityType;
                    cmd.Parameters.Add("@wardnumber", SqlDbType.Int).Value = usrRegister.wardnumber;
                    cmd.Parameters.Add("@address", SqlDbType.VarChar).Value = usrRegister.address;
                    cmd.Parameters.Add("@pincode", SqlDbType.VarChar).Value = usrRegister.pincode;
                    

                    int resultRows=cmd.ExecuteNonQuery();

                    return new HttpResponseMessage(HttpStatusCode.OK);
                }
            }        
        }
    }

    [Serializable]
    public class UserRegistrationEntity
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string EntityType { get; set; }
        public string foodEntityType { get; set; }
        public int wardnumber { get; set; }
        public string address { get; set; }
        public string pincode { get; set; }
    }
}
