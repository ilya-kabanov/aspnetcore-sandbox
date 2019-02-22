FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["AspNetCoreSandbox/AspNetCoreSandbox.csproj", "AspNetCoreSandbox/"]
RUN dotnet restore "AspNetCoreSandbox/AspNetCoreSandbox.csproj"
COPY . .
WORKDIR "/src/AspNetCoreSandbox"
RUN dotnet build "AspNetCoreSandbox.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "AspNetCoreSandbox.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AspNetCoreSandbox.dll"]
