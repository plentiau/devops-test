using NUnit.Framework;
using System.Collections;

namespace ExampleService.UnitTests
{
    [TestFixture]
    public class Tests
    {
        [TestCaseSource(typeof(CelsiusToFahrenheitData), nameof(CelsiusToFahrenheitData.TestCases))]
        [Description("Convert celsius value to fahrenheit")]
        public int ConversionCelsiusToFahrenheit(int c)
        {
            var forecast = new WeatherForecast() { TemperatureC = c };

            return forecast.TemperatureF;
        }

        [TestCaseSource(typeof(CelsiusToFahrenheitData), nameof(CelsiusToFahrenheitData.TestCases))]
        [Description("Convert celsius value to a descriptive summary")]
        public string CelsiusToSummary(int c)
        {
            var forecast = new WeatherForecast() { TemperatureC = c };

            return forecast.Summary;
        }
    }

    public class CelsiusToFahrenheitData
    {
        public static IEnumerable TestCases
        {
            get
            {
                yield return new TestCaseData(30).Returns(85);
                yield return new TestCaseData(-30).Returns(-21);
                yield return new TestCaseData(0).Returns(32);
                yield return new TestCaseData(100).Returns(211);
            }
        }
    }

    public class CelsiusToSummaryData
    {
        public static IEnumerable TestCases
        {
            get
            {
                yield return new TestCaseData(-20).Returns("Freezing");
                yield return new TestCaseData(3).Returns("Bracing");
                yield return new TestCaseData(9).Returns("Chilly");
                yield return new TestCaseData(13).Returns("Cool");
                yield return new TestCaseData(19).Returns("Mild");
                yield return new TestCaseData(21).Returns("Warm");
                yield return new TestCaseData(24).Returns("Balmy");
                yield return new TestCaseData(29).Returns("Hot");
                yield return new TestCaseData(32).Returns("Sweltering");
                yield return new TestCaseData(40).Returns("Scorching");
            }
        }
    }
}