using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace IdentityProvider.Components
{
    [Table("AppRegistrations")]
    public class AppRegistration
    {
        [Key]
        [Required]
        [MaxLength(100)]
        public required string ClientId { get; set; }

        [Required]
        [MaxLength(200)]
        public required string ClientSecret { get; set; }

        [Required]
        [MaxLength(100)]
        public required string TenantId { get; set; }

        [Required]
        [MaxLength(200)]
        public required string RedirectUri { get; set; }

        [Required]
        public required string Scopes { get; set; } // Comma-separated

        [Required]
        [MaxLength(200)]
        public required string Authority { get; set; }

        [Required]
        [MaxLength(100)]
        public required string AppName { get; set; }

        [MaxLength(500)]
        public string? AppDescription { get; set; }

        [Required]
        public required string GrantTypes { get; set; } // Comma-separated

        [Required]
        public required string ResponseTypes { get; set; } // Comma-separated
    }
}
