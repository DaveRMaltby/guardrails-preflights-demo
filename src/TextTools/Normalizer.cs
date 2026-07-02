using System.Globalization;
using System.Text;

namespace TextTools;

/// <summary>
/// Normalizes text for consistent comparison and downstream processing (e.g. slugification).
/// </summary>
public static class Normalizer
{
    /// <summary>
    /// Lowercases, strips diacritics, and collapses whitespace in the input string.
    /// </summary>
    public static string Normalize(string s)
    {
        var lowered = s.ToLowerInvariant();

        var decomposed = lowered.Normalize(NormalizationForm.FormD);
        var withoutDiacritics = new StringBuilder(decomposed.Length);
        foreach (var c in decomposed)
        {
            if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
            {
                withoutDiacritics.Append(c);
            }
        }

        var recomposed = withoutDiacritics.ToString().Normalize(NormalizationForm.FormC);

        var collapsed = new StringBuilder(recomposed.Length);
        var lastWasWhitespace = false;
        foreach (var c in recomposed)
        {
            if (char.IsWhiteSpace(c))
            {
                lastWasWhitespace = true;
                continue;
            }

            if (lastWasWhitespace && collapsed.Length > 0)
            {
                collapsed.Append(' ');
            }

            lastWasWhitespace = false;
            collapsed.Append(c);
        }

        return collapsed.ToString();
    }
}
