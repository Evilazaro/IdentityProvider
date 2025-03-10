var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.Identity_IdentityProvider>("identity-identityprovider");

builder.Build().Run();
