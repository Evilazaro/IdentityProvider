namespace IdentityProvider.Components
{
    public class eMail
    {
        public bool checkEmail(string email)
        {
            // Check if the email is in a valid format
            if (string.IsNullOrEmpty(email) || !email.Contains("@"))
            {
                return false;
            }
            // Check if the email domain is valid
            string[] validDomains = { "example.com", "test.com" };
            string domain = email.Split('@')[1];
            return validDomains.Contains(domain);
        }
    }
}
