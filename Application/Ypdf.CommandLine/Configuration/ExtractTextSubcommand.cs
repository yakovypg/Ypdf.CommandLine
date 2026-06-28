using NetArgumentParser.Attributes;
using Ypdf.Core.Extraction;

namespace Ypdf.CommandLine.Configuration;

internal sealed class ExtractTextSubcommand
{
    internal const string Name = "extract-text";
    internal const string Description = "Extract text from the PDF document";

    internal const string InputPathLongName = "input";
    internal const string OutputPathLongName = "output";
    internal const string TextExtractorLongName = "text-extractor";
    internal const string UseTikaLongName = "use-tika";
    internal const string TikaServerJarPathLongName = "tika-jar";

    internal const string DefaultTextExtractor = nameof(TextExtractors.Simple);

    [ValueOption<string>(
        longName: InputPathLongName,
        shortName: "i",
        description: "path to the input file",
        isRequired: true,
        valueRestriction: "file pdf\n?input path must point to a .pdf file")
    ]
    [OptionGroup("paths", "Paths", "Options for configuring paths")]
    public string InputPath { get; set; } = string.Empty;

    [ValueOption<string>(
        longName: OutputPathLongName,
        shortName: "o",
        description: "path to the output file",
        isRequired: true)
    ]
    [OptionGroup("paths", "", "")]
    public string OutputPath { get; set; } = string.Empty;

    [ValueOption<ITextExtractor>(
        longName: TextExtractorLongName,
        shortName: "e",
        description: $"text extractor for the case where Tika is not used [default={DefaultTextExtractor}]",
        addBeforeParseChoicesToDescription: true,
        ignoreCaseInChoices: true,
        beforeParseChoices:
        [
            nameof(TextExtractors.Simple),
            nameof(TextExtractors.LocationBased)
        ])
    ]
    public ITextExtractor TextExtractor { get; set; } = TextExtractors.Parse(DefaultTextExtractor);

    [FlagOption(
        longName: UseTikaLongName,
        shortName: "t",
        description: "use Tika for text extraction")
    ]
    public bool UseTika { get; set; }

    [ValueOption<string>(
        longName: TikaServerJarPathLongName,
        shortName: "j",
        description: "path to the tika server .jar file",
        valueRestriction: "file jar\n?input path must point to a .jar file")
    ]
    public string TikaServerJarPath { get; set; } = string.Empty;
}
