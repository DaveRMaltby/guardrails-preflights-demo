using TextTools;
using Xunit;

namespace TextTools.Tests;

public class SlugifyTests
{
    [Theory]
    [InlineData("Héllo, World!", "hello-world")]
    [InlineData("  Multiple   Spaces  ", "multiple-spaces")]
    [InlineData("Café del Mar", "cafe-del-mar")]
    [InlineData("!!!Wow!!!", "wow")]
    public void Slugify_ProducesExpectedSlug(string input, string expected)
    {
        Assert.Equal(expected, TextExtensions.Slugify(input));
    }
}
