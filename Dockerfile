FROM microsoft/aspnetcore:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.2 AS build
WORKDIR /src
COPY ["aspcore/aspcore.csproj", "aspcore/"]
RUN dotnet restore "aspcore/aspcore.csproj"
COPY . .
WORKDIR "/src/aspcore"
RUN dotnet build "aspcore.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "aspcore.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "aspcore.dll"]
