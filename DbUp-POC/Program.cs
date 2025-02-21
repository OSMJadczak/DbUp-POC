using System.CommandLine;
using Commands = DbUp_POC.Infrastructure.Commands;

namespace DbUp_POC
{
    internal static class Program
    {
        static async Task Main(string[] args)
        {
            var rootCommand = InitializeCommand();
            await rootCommand.InvokeAsync(args);
        }

        private static RootCommand InitializeCommand()
        {
            var rootCommand = new RootCommand();

            var scriptsFolderOption = new Option<string>(
                name: "--scripts-folder",
                description: "Root folder containing both upgrade and downgrade scripts. Folder named 'up' must contain upgrade and 'down' must contain downgrade.")
            {
                IsRequired = true
            };
            scriptsFolderOption.AddAlias("-f");
            scriptsFolderOption.AddAlias("--files");

            var initialScriptsOption = new Option<string>(
                name: "--initial-scripts",
                description: "Folder containing initial database state scripts. Only used in test.")
            {
                IsRequired = false
            };
            initialScriptsOption.AddAlias("-i");
            initialScriptsOption.AddAlias("--init");

            var connectionStringOption = new Option<string>(
                name: "--connection-string",
                description: "Connection string to the database. Ignored on test, required in other methods.")
            {
                IsRequired = false
            };
            connectionStringOption.AddAlias("-c");
            connectionStringOption.AddAlias("--conn");
            connectionStringOption.AddAlias("-cs");

            rootCommand.AddGlobalOption(scriptsFolderOption);
            rootCommand.AddGlobalOption(connectionStringOption);
            rootCommand.AddGlobalOption(initialScriptsOption);

            rootCommand.AddCommand(Commands.Test(scriptsFolderOption, initialScriptsOption, connectionStringOption));
            rootCommand.AddCommand(Commands.Upgrade(scriptsFolderOption, connectionStringOption));
            rootCommand.AddCommand(Commands.Downgrade(scriptsFolderOption, connectionStringOption));
            rootCommand.AddCommand(Commands.Cleanup(scriptsFolderOption, connectionStringOption));
            return rootCommand;
        }
    }
}
