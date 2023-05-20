#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0-bullseye-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

ENV NODE_VERSION 18.16.0
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
ENV NODE_DOWNLOAD_SHA FC83046A93D2189D919005A348DB3B2372B598A145D84EB9781A3A4B0F032E95

RUN dotnet dev-certs https \
    && curl -SL "$NODE_DOWNLOAD_URL" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && node --version \
    && npm install -g npm@9.6.7

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
