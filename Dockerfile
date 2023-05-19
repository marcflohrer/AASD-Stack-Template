FROM mcr.microsoft.com/dotnet/sdk:7.0@sha256:7c808ca379d3836044627a0bb5d4fc84520f41bca775706d37ca6863fea3567b AS build

WORKDIR /app
COPY AspNet.Angular.Template.csproj .
RUN dotnet restore AspNet.Angular.Template.csproj
COPY . .
RUN dotnet build AspNet.Angular.Template.csproj
RUN dotnet dev-certs https

RUN apt-get update && \
      apt-get -y install sudo
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

FROM build AS publish
RUN dotnet publish AspNet.Angular.Template.csproj -c Release -o /app  --self-contained=false

FROM mcr.microsoft.com/dotnet/aspnet:7.0-jammy AS final

ENV DOTNET_TieredPGO = 1
ENV DOTNET_TC_QuickJitForLoops = 1
ENV DOTNET_TieredCompilation = 1
ENV DOTNET_TC_QuickJit = 1
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:6003;https://+:6004

# Install Node.js and npm
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install \
       npm list --depth=0

EXPOSE 6003 6004
WORKDIR /app

COPY --from=publish /app .
COPY --from=publish /app/etc/ssl/openssl.cnf /etc/ssl/openssl.cnf
COPY --from=build /root/.dotnet/corefx/cryptography/x509stores/my/* /root/.dotnet/corefx/cryptography/x509stores/my/

ENTRYPOINT ["dotnet", "AspNet.Angular.Template.dll"]