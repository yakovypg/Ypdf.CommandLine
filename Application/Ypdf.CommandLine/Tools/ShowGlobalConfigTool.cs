using Ypdf.CommandLine.AppConfig;
using Ypdf.CommandLine.Exceptions;
using Ypdf.Core.Tools;

namespace Ypdf.CommandLine.Tools;

internal sealed class ShowGlobalConfigTool : ITool
{
    private readonly GlobalConfig _currentGlobalConfig;

    internal ShowGlobalConfigTool(GlobalConfig currentGlobalConfig)
    {
        ExtendedArgumentNullException.ThrowIfNull(currentGlobalConfig, nameof(currentGlobalConfig));
        _currentGlobalConfig = currentGlobalConfig;
    }

    public void Execute(string inputPath, string outputPath)
    {
        /*
         * Input path is not used
         * Output path is not used
        */

        string content = _currentGlobalConfig.Serialize();
        _currentGlobalConfig.OutputWriter?.WriteLine(content);
    }
}
