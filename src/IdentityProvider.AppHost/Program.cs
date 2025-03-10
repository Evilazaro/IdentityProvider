var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.Identity_IdentityProvider>("identityprovider");

builder.Build().Run();
