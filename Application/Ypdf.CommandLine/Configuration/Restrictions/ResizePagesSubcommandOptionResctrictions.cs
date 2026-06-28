using System;
using System.Collections.Generic;
using NetArgumentParser.Subcommands;
using Ypdf.CommandLine.Configuration.Subcommands;
using Ypdf.CommandLine.Exceptions;
using Ypdf.Core.Design.Pages;

namespace Ypdf.CommandLine.Configuration.Restrictions;

internal sealed class ResizePagesSubcommandOptionResctrictions : OptionRestrictions
{
    protected override IReadOnlyCollection<Action<ParserQuantum>> ConfigurationProviders =>
    [
        AddRestrictionForPageResizingsOption
    ];

    private static void AddRestrictionForPageResizingsOption(ParserQuantum parserQuantum)
    {
        ExtendedArgumentNullException.ThrowIfNull(parserQuantum, nameof(parserQuantum));

        AddRestrictionForPageResizingEnumerableOption<IList<PageResizing>>(
            parserQuantum: parserQuantum,
            optionLongName: ResizePagesSubcommand.PageResizingsLongName,
            minPage: 1,
            minWidth: 1,
            minHeight: 1);
    }
}
