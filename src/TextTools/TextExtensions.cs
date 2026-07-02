namespace TextTools;

/// <summary>
/// String helper extensions for TextTools.
/// </summary>
public static class TextExtensions
{
    /// <summary>
    /// Returns the input string with its characters in reverse order.
    /// </summary>
    public static string Reverse(string s)
    {
        ArgumentNullException.ThrowIfNull(s);

        var chars = s.ToCharArray();
        Array.Reverse(chars);
        return new string(chars);
    }

    /// <summary>
    /// Counts whitespace-delimited words in the input string.
    /// Returns 0 for null, empty, or whitespace-only input.
    /// </summary>
    public static int WordCount(string s)
    {
        if (string.IsNullOrWhiteSpace(s))
        {
            return 0;
        }

        return s.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries).Length;
    }
}
