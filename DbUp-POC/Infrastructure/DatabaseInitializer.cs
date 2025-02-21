using DbUp;
using Microsoft.Data.SqlClient;
using Testcontainers.MsSql;

namespace DbUp_POC.Infrastructure
{
    public static class DatabaseInitializer
    {
        public async static Task<string> InitializeDatabase(string initialScriptsFolder = "")
        {
            var dbContainer = new MsSqlBuilder()
                .WithImage("mcr.microsoft.com/mssql/server:2022-CU13-ubuntu-22.04")
                .WithPassword("Strong_password_123!")
                .WithPortBinding("5001", "1433")
                .WithName("DbUp-Test")
                .WithCleanUp(false)
                .WithReuse(true)
                .Build();

            await dbContainer.StartAsync();
            var builder = new SqlConnectionStringBuilder(dbContainer.GetConnectionString())
            {
                InitialCatalog = "test",
                TrustServerCertificate = true,
                IntegratedSecurity = false,
            };

            EnsureDatabase.For.SqlDatabase(builder.ConnectionString);

            if (!string.IsNullOrEmpty(initialScriptsFolder))
            {
                var upgradeEngine = DeployChanges.To.SqlDatabase(builder.ConnectionString)
                    .WithScriptsFromFileSystem(Path.Combine(Directory.GetCurrentDirectory(), "init"))
                    .LogToConsole()
                    .Build();

                foreach (var script in upgradeEngine.GetScriptsToExecute())
                {
                    Console.WriteLine(script.Name);
                }

                upgradeEngine.PerformUpgrade();
            }

            return builder.ConnectionString;
        }
    }
}
