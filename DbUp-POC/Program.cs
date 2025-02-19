using DbUp;
using DbUp.Downgrade;
using DbUp.Downgrade.Helpers;
using DbUp.Engine.Output;
using DbUp.ScriptProviders;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Testcontainers.MsSql;

namespace DbUp_POC
{
    internal static class Program
    {
        static async Task Main(string[] args)
        {
            var connectionString = await InitializeDatabase();
            var config = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();
            var upgradeScripts = new FileSystemScriptProvider(Path.Combine(Directory.GetCurrentDirectory(), config["MigrationScriptsPaths:Up"]));
            var downgradeScripts = new FileSystemScriptProvider(Path.Combine(Directory.GetCurrentDirectory(), config["MigrationScriptsPaths:Down"]));

            var upgradeEngine = DeployChanges.To.SqlDatabase(connectionString)
                .WithExecutionTimeout(TimeSpan.FromSeconds(240))
                .WithScripts(upgradeScripts)
                .WithDowngradeTableProvider<SqlDowngradeEnabledTableJournal>(downgradeScripts, new DefaultDowngradeScriptFinder())
                .LogTo(new ConsoleUpgradeLog())
                .WithTransaction() // rolls back migrations in case of an exception
                .BuildWithDowngrade(false);

            var scripts = upgradeEngine.UpgradeEngine.GetScriptsToExecute();
            foreach (var item in scripts)
            {
                Console.WriteLine(item.Name);
            }

            Console.WriteLine("U for upgrade, D for downgrade");
            var a = Console.ReadKey();
            while (a.Key != ConsoleKey.U && a.Key != ConsoleKey.D)
            {
                a = Console.ReadKey();
            }

            if (a.Key == ConsoleKey.U)
            {
                upgradeEngine.PerformUpgrade();

                Console.WriteLine("If you want to downgrade, press D. Press anything else to exit.");
                a = Console.ReadKey();
                if (a.Key == ConsoleKey.D)
                {
                    upgradeEngine.PerformDowngradeForScripts(upgradeEngine.UpgradeEngine.GetExecutedScripts().ToArray());
                }
                else Environment.Exit(0);
            }
            if (a.Key == ConsoleKey.D)
            {
                upgradeEngine.PerformDowngradeForScripts(upgradeEngine.UpgradeEngine.GetExecutedScripts().ToArray());
            }
        }

        private async static Task<string> InitializeDatabase()
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

            var upgradeEngine = DeployChanges.To.SqlDatabase(builder.ConnectionString)
                .WithScriptsFromFileSystem(Path.Combine(Directory.GetCurrentDirectory(), "init"))
                .LogToConsole()
                .Build();

            EnsureDatabase.For.SqlDatabase(builder.ConnectionString);

            foreach (var script in upgradeEngine.GetScriptsToExecute())
            {
                Console.WriteLine(script.Name);
            }

            upgradeEngine.PerformUpgrade();
            return builder.ConnectionString;
        }
    }
}
