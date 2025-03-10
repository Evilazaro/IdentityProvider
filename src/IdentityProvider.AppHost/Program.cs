var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.Identity_IdentityProvider>("identityprovider","https").WithExternalHttpEndpoints();
builder.Build().Run();
