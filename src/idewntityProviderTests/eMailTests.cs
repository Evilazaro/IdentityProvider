using IdentityProvider.Components;

namespace IdentityProvider.Tests.Components
{
    [TestClass]
    public class eMailTests
    {
        [DataTestMethod]
        [DataRow("user@example.com", true)]
        [DataRow("user@test.com", true)]
        [DataRow("user@invalid.com", false)]
        [DataRow("invalidemail.com", false)]
        [DataRow("", false)]
        [DataRow(null, false)]
        public void CheckEmail_ShouldValidateEmailCorrectly(string email, bool expected)
        {
            // Arrange
            var emailChecker = new eMail();

            // Act
            var result = emailChecker.checkEmail(email);

            // Assert
            Assert.AreEqual(expected, result);
        }
    }
}
