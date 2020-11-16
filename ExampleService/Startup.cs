using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace ExampleService
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddLogging();
            services.AddControllers();
            services.AddHealthChecks();
            services.AddSwaggerGen();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger<Startup> logger)
        {
            if (env.IsDevelopment())
            {
                logger.LogWarning("Running in Development environment");
                app.UseDeveloperExceptionPage();
            }
            else
            {
                logger.LogInformation("Not running in Development environment");
                app.UseHsts();
                app.UseHttpsRedirection();
            }

            app.UseRouting();
            app.UseSwagger();
            app.UseSwaggerUI(opt =>
            {
                opt.SwaggerEndpoint("/swagger/v1/swagger.json", "Example API");
            });

            app.UseEndpoints(endpoints =>
           {
               endpoints.MapControllers();
               endpoints.MapHealthChecks("/health");
           });

        }
    }
}
