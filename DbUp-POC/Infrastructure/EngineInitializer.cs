using DbUp;
using DbUp.Downgrade;
using DbUp.Downgrade.Helpers;
using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.ScriptProviders;
using DbUp.Support;

namespace DbUp_POC.Infrastructure
{
    public static class EngineInitializer
    {
        public static DowngradeEnabledUpgradeEngine InitializeUpgradeDowngradeEngine(string connectionString, string migrationsFolder, bool isCleanup = false)
        {
            var upgradeScripts = new FileSystemScriptProvider(isCleanup ? migrationsFolder : Path.Combine(migrationsFolder, "up"));
            var downgradeScripts = new FileSystemScriptProvider(
                directoryPath: isCleanup
                    ? migrationsFolder
                    : Path.Combine(migrationsFolder, "down"),
                new FileSystemScriptOptions(),
                sqlScriptOptions: isCleanup
                    ? new SqlScriptOptions { ScriptType = ScriptType.RunAlways }
                    : new SqlScriptOptions());

            var upgradeEngine = DeployChanges.To.SqlDatabase(connectionString)
                .WithExecutionTimeout(TimeSpan.FromSeconds(240))
                .WithScripts(upgradeScripts)
                .WithDowngradeTableProvider<SqlDowngradeEnabledTableJournal>(downgradeScripts, new DefaultDowngradeScriptFinder())
                .LogTo(new ConsoleUpgradeLog())
                .WithTransaction() // rolls back migrations in case of an exception
                .BuildWithDowngrade(false);

            EnsureDatabase.For.SqlDatabase(connectionString);

            return upgradeEngine;
        }
    }
}
