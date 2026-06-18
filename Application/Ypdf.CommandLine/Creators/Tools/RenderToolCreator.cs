using System;
using Ypdf.CommandLine.AppConfig;
using Ypdf.CommandLine.Configuration;
using Ypdf.CommandLine.Exceptions;
using Ypdf.Core.Execution;
using Ypdf.Core.Imaging;
using Ypdf.Core.Runtime.Logging;
using Ypdf.Core.Tools;

namespace Ypdf.CommandLine.Creators.Tools;

internal sealed class RenderToolCreator : ToolCreator
{
    public RenderToolCreator(GlobalConfig globalConfig)
        : base(globalConfig ?? throw new ArgumentNullException(nameof(globalConfig))) { }

    public override IToolExecutionProvider Create(YpdfParserConfig config)
    {
        ExtendedArgumentNullException.ThrowIfNull(config, nameof(config));

        RenderSubcommand subcommand = config.RenderSubcommand;
        ImageRendering imageRendering = new(subcommand.Dpi, subcommand.Extension);

        string pythonAlias = Config.PythonAlias;
        string virtualEnvironmentPath = Config.VirtualEnvironmentPath;
        IOutputWriter outputWriter = Config.OutputWriter;

        RenderTool tool = new(
            pages: subcommand.Pages.Count > 0 ? subcommand.Pages : null,
            imageRendering: imageRendering,
            pythonAlias: pythonAlias,
            virtualEnvironmentPath: virtualEnvironmentPath,
            outputWriter: outputWriter);

        ToolExecutionParameters toolExecutionParameters = new(
            tool,
            [subcommand.InputPath],
            subcommand.OutputPath);

        return new ToolExecutionProvider(toolExecutionParameters);
    }
}
