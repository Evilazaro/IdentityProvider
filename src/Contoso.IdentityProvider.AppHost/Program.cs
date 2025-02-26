var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.Contoso_IdentityProvider>("contoso-identityprovider");

builder.Build().Run();
