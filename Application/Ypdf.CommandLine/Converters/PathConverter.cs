using System.IO;

namespace Ypdf.CommandLine.Converters;

internal static class PathConverter
{
    internal static string ToAbsolutePath(string relativePath)
    {
        if (string.IsNullOrWhiteSpace(relativePath))
            relativePath = ".";

        return Path.GetFullPath(relativePath);
    }
}
