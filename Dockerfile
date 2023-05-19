#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0-bullseye-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

RUN dotnet dev-certs https \
    && apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @angular/cli

COPY ["AspNetAngularTemplate/AspNetAngularTemplate.csproj", "AspNetAngularTemplate/"]
RUN dotnet restore "AspNetAngularTemplate/AspNetAngularTemplate.csproj"
COPY . .
WORKDIR "/src/AspNetAngularTemplate"
RUN dotnet build "AspNetAngularTemplate.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspNetAngularTemplate.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app

EXPOSE 44461 44462

COPY --from=build /root/.dotnet/corefx/cryptography/x509stores/my/* /root/.dotnet/corefx/cryptography/x509stores/my/
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "AspNetAngularTemplate.dll"]
