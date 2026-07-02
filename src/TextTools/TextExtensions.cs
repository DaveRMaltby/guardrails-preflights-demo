using System.Text;

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

    /// <summary>
    /// Converts the input string into a URL-friendly slug: lowercase, accents
    /// stripped, non-alphanumeric runs collapsed to a single hyphen, and
    /// leading/trailing hyphens trimmed.
    /// </summary>
    public static string Slugify(string s)
    {
        ArgumentNullException.ThrowIfNull(s);

        var normalized = Normalizer.Normalize(s);

        var slug = new StringBuilder(normalized.Length);
        var lastWasHyphen = false;
        foreach (var c in normalized)
        {
            if (char.IsLetterOrDigit(c))
            {
                slug.Append(c);
                lastWasHyphen = false;
            }
            else if (!lastWasHyphen && slug.Length > 0)
            {
                slug.Append('-');
                lastWasHyphen = true;
            }
        }

        if (slug.Length > 0 && slug[^1] == '-')
        {
            slug.Length--;
        }

        return slug.ToString();
    }
}
