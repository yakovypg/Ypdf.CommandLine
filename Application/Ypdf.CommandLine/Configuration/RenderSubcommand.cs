using System.Collections.Generic;
using NetArgumentParser.Attributes;
using NetArgumentParser.Options.Context;
using Ypdf.Core.Enumeration;

namespace Ypdf.CommandLine.Configuration;

internal sealed class RenderSubcommand
{
    internal const string Name = "render";
    internal const string Description = "Convert PDF document pages to images";

    internal const string InputPathLongName = "input";
    internal const string OutputPathLongName = "output";
    internal const string PagesLongName = "pages";
    internal const string ExtensionLongName = "extension";
    internal const string DpiLongName = "dpi";

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

    [MultipleValueOption<PageRange>(
        longName: PagesLongName,
        shortName: "p",
        description: "page number or page range (N or S-E -> 1 or 3-5)",
        contextCaptureType: ContextCaptureType.OneOrMore)
    ]
    [OptionGroup("paging", "Paging", "Options for configuring paging")]
    public List<PageRange> Pages { get; set; } = [];

    [ValueOption<string>(
        defaultValue: "jpg",
        longName: ExtensionLongName,
        shortName: "e",
        description: "output images extension",
        choices: ["jpg", "jpeg", "png", "bmp", "gif", "tiff"],
        ignoreCaseInChoices: true,
        addDefaultValueToDescription: true,
        addChoicesToDescription: true)
    ]
    [OptionGroup("rendering", "Rendering", "Options for configuring rendering")]
    public string Extension { get; set; } = string.Empty;

    [ValueOption<int>(
        defaultValue: 150,
        longName: DpiLongName,
        shortName: "d",
        description: "output images DPI",
        addDefaultValueToDescription: true,
        valueRestriction: "min 1\n?DPI must be >= 1")
    ]
    [OptionGroup("rendering", "", "")]
    public int Dpi { get; set; }
}
