using TextTools;
using Xunit;

namespace TextTools.Tests;

public class NormalizerTests
{
    [Theory]
    [InlineData("HELLO", "hello")]
    [InlineData("Hello World", "hello world")]
    [InlineData("already lower", "already lower")]
    public void Normalize_LowercasesInput(string input, string expected)
    {
        Assert.Equal(expected, Normalizer.Normalize(input));
    }

    [Theory]
    [InlineData("Héllo", "hello")]
    [InlineData("Café", "cafe")]
    [InlineData("über", "uber")]
    public void Normalize_StripsDiacritics(string input, string expected)
    {
        Assert.Equal(expected, Normalizer.Normalize(input));
    }

    [Theory]
    [InlineData("  a   b  ", "a b")]
    [InlineData("one   two   three", "one two three")]
    [InlineData("  leading", "leading")]
    [InlineData("trailing  ", "trailing")]
    public void Normalize_CollapsesInternalWhitespaceAndTrimsEnds(string input, string expected)
    {
        Assert.Equal(expected, Normalizer.Normalize(input));
    }
}
