using System.CommandLine;

namespace DbUp_POC.Infrastructure
{
    public static class Commands
    {
        public static Command Test(Option<string> scriptsPathOption, Option<string> initialScriptsPathOption, Option<string> connectionStringOption)
        {
            var testCommand = new Command("test", "Initialize a test container and run scripts against it. Requires init folder with script(s) containing initial database state. Connection string will be omitted.")
            {
                scriptsPathOption,
                initialScriptsPathOption,
                connectionStringOption
            };
            testCommand.AddAlias("dryrun");
            testCommand.AddAlias("verify");

            testCommand.SetHandler(async (folder, initialScriptsFolder, connectionString) =>
            {
                Console.WriteLine("Running test.");

                var initialPathValidation = Helpers.CheckIfPathExists(initialScriptsFolder, false);
                if (!initialPathValidation.Item1)
                {
                    Console.WriteLine("Path specified for initial scripts is not correct or it does not exist. No initial scripts will run.");
                }
                initialScriptsFolder = initialPathValidation.Item1 ? initialPathValidation.Item2 : string.Empty;
                connectionString = await DatabaseInitializer.InitializeDatabase(initialScriptsFolder);

                Console.WriteLine("Database has been created and upgraded to initial state.");

                var engine = EngineInitializer.InitializeUpgradeDowngradeEngine(connectionString, folder);
                Helpers.PrintScriptsToExecute(engine);

                Console.WriteLine("Upgrading database.");
                engine.PerformUpgrade();

                Console.WriteLine("Database has been successfully upgraded. Reverting...");

                engine.PerformDowngradeForScripts(engine.UpgradeEngine.GetExecutedScripts().ToArray());
                Console.WriteLine("Database has been downgraded successfully.");
            }, scriptsPathOption, initialScriptsPathOption, connectionStringOption);

            return testCommand;
        }

        public static Command Upgrade(Option<string> scriptsPathOption, Option<string> connectionStringOption)
        {
            var upgradeCommand = new Command("upgrade", "Upgrade the database with scripts in the specified folder. Connection string is required.")
            {
                scriptsPathOption,
                connectionStringOption
            };
            upgradeCommand.AddAlias("migrate");

            upgradeCommand.SetHandler((folder, connectionString) =>
            {
                Helpers.ValidateConnectionStringAndThrow(connectionString);
                var pathResult = Helpers.ValidatePathAndThrow(folder).Item2;

                var engine = EngineInitializer.InitializeUpgradeDowngradeEngine(connectionString, pathResult);

                Console.WriteLine("Validation complete, engine initialized. Upgrading database.");
                Helpers.PrintScriptsToExecute(engine);

                engine.PerformUpgrade();

                Console.WriteLine("Database upgraded successfully.");
            }, scriptsPathOption, connectionStringOption);

            return upgradeCommand;
        }

        public static Command Downgrade(Option<string> scriptsPathOption, Option<string> connectionStringOption)
        {
            var downgradeCommand = new Command("downgrade", "Downgrade the specified database.")
            {
                scriptsPathOption,
                connectionStringOption
            };
            downgradeCommand.AddAlias("rollback");
            downgradeCommand.AddAlias("revert");

            downgradeCommand.SetHandler((folder, connectionString) =>
            {
                Helpers.ValidateConnectionStringAndThrow(connectionString);
                var pathResult = Helpers.ValidatePathAndThrow(folder).Item2;
                var engine = EngineInitializer.InitializeUpgradeDowngradeEngine(connectionString, pathResult);

                Console.WriteLine("Validation complete, engine initialized. Downgrading database.");
                Helpers.PrintScriptsToExecute(engine, isDowngrade: true);

                engine.PerformDowngradeForScripts(engine.UpgradeEngine.GetExecutedScripts().ToArray());

                Console.WriteLine("Downgrade completed. Cleaning up.");

                var cleanupScriptsPath = Path.Combine(pathResult, "cleanup");
                if (Directory.Exists(cleanupScriptsPath))
                {
                    engine = EngineInitializer.InitializeUpgradeDowngradeEngine(connectionString, cleanupScriptsPath, true);
                    Helpers.PrintScriptsToExecute(engine);
                    engine.PerformUpgrade();

                    Console.WriteLine("Cleanup scripts executed successfully.");
                }

                Console.WriteLine("Database downgraded successfully.");
            }, scriptsPathOption, connectionStringOption);

            return downgradeCommand;
        }

        public static Command Cleanup(Option<string> scriptsPathOption, Option<string> connectionStringOption)
        {
            var cleanupCommand = new Command("cleanup", "Run cleanup scripts.")
            {
                scriptsPathOption,
                connectionStringOption
            };
            cleanupCommand.AddAlias("clean");

            cleanupCommand.SetHandler((folder, connectionString) =>
            {
                Helpers.ValidateConnectionStringAndThrow(connectionString);
                folder = Path.Combine(Directory.GetCurrentDirectory(), folder);
                var pathResult = Helpers.CheckIfPathExists(folder, false);

                if (!pathResult.Item1 || Directory.GetFiles(pathResult.Item2).Length == 0)
                {
                    Console.WriteLine("Path does not exist or does not contain any files. Exiting.");
                    return;
                }

                Console.WriteLine(pathResult.Item2);

                var engine = EngineInitializer.InitializeUpgradeDowngradeEngine(connectionString, pathResult.Item2, isCleanup: true);

                Console.WriteLine("Validation complete, engine initialized. Running cleanup scripts.");
                Helpers.PrintScriptsToExecute(engine);

                engine.PerformUpgrade();
                engine.PerformDowngrade();
                Console.WriteLine("Database cleaned successfully.");
            }, scriptsPathOption, connectionStringOption);

            return cleanupCommand;
        }
    }
}
