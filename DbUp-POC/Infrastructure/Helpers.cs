using DbUp.Downgrade;

namespace DbUp_POC.Infrastructure
{
    public static class Helpers
    {
        public static (bool, string) ValidatePathAndThrow(string path)
        {
            var validation = CheckIfPathExists(path);
            if (!validation.Item1)
            {
                throw new Exception($"Path specified for scripts is not correct or it does not exist. Path: {path}");
            }

            return validation;
        }

        public static (bool, string) CheckIfPathExists(string path, bool validateForUpgrade = true)
        {
            var targetPath = Path.Combine(Directory.GetCurrentDirectory(), path);
            return (!string.IsNullOrEmpty(path)
                && Directory.Exists(targetPath)
                && (validateForUpgrade
                    ? Directory.Exists(Path.Combine(targetPath, "up")) && Directory.Exists(Path.Combine(targetPath, "down"))
                    : true), targetPath);
        }

        public static void ValidateConnectionStringAndThrow(string connectionString)
        {
            if (!ValidateConnectionString(connectionString))
            {
                throw new Exception("Connection string must be specified for this operation.");
            }
        }

        public static bool ValidateConnectionString(string connectionString)
        {
            return !string.IsNullOrEmpty(connectionString);
        }

        public static void PrintScriptsToExecute(DowngradeEnabledUpgradeEngine engine, bool isDowngrade = false)
        {
            var scriptsToExecute = isDowngrade
                ? engine.UpgradeEngine.GetExecutedScripts()
                : engine.UpgradeEngine.GetScriptsToExecute().Select(x => x.Name);

            Console.WriteLine($"Found {scriptsToExecute.Count()} scripts to run:");
            foreach (var script in scriptsToExecute)
            {
                Console.WriteLine(script);
            }
        }
    }
}
