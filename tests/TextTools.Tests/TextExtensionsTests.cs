using TextTools;
using Xunit;

namespace TextTools.Tests;

public class TextExtensionsTests
{
    [Theory]
    [InlineData("abc", "cba")]
    [InlineData("racecar", "racecar")]
    [InlineData("", "")]
    public void Reverse_ReversesCharacters(string input, string expected)
    {
        Assert.Equal(expected, TextExtensions.Reverse(input));
    }

    [Fact]
    public void Reverse_PreservesWhitespaceAndCase()
    {
        Assert.Equal("dlroW olleH", TextExtensions.Reverse("Hello World"));
    }

    [Theory]
    [InlineData("one two three", 3)]
    [InlineData("  leading and   trailing  ", 3)]
    [InlineData("single", 1)]
    public void WordCount_CountsWhitespaceDelimitedWords(string input, int expected)
    {
        Assert.Equal(expected, TextExtensions.WordCount(input));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null)]
    public void WordCount_ReturnsZeroForNullEmptyOrWhitespace(string? input)
    {
        Assert.Equal(0, TextExtensions.WordCount(input!));
    }
}
