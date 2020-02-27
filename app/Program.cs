using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration.AzureAppConfiguration;

namespace app
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                    webBuilder.ConfigureAppConfiguration((hostingContext, config) =>
                    {
                        var settings = config.Build();

                        // Default configuration (required app restart to update configuration) 
                        // config.AddAzureAppConfiguration(settings["AppConfig"]);

                        config.AddAzureAppConfiguration(options =>
                        {
                            options.Connect(settings["AppConfig"]).ConfigureRefresh(configure =>
                            {
                                configure.Register("TestApp:Settings:BackgroundColor");
                            }).UseFeatureFlags();
                        });
                    });
                });
    }
}
