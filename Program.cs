
namespace InvestorDashboard;

public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
            .ConfigureAppConfiguration((hostContext, webBuilder) =>
            {
                webBuilder.AddEnvironmentVariables();
                webBuilder.AddJsonFile("appsettings.json", optional: false, reloadOnChange: false);
                webBuilder.AddJsonFile($"appsettings.{hostContext.HostingEnvironment.EnvironmentName}.json", optional: true);
                webBuilder.AddUserSecrets<Program>();
                webBuilder.AddJsonFile("secrets/appsettings.json", optional: true, reloadOnChange: false);

            })
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder
                .SuppressStatusMessages(true)
                .UseStartup<Startup>();
            });
    }
