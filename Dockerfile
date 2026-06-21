FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app/src

# Copy configuration files
COPY Ypdf.CommandLine.slnx ./
COPY Directory.Build.props ./
COPY Directory.Packages.props ./
COPY stylecop.json ./
COPY .ruleset ./
COPY .editorconfig ./

# Copy sources
COPY Shared/. ./Shared/
COPY Core/Ypdf.Core/. ./Core/Ypdf.Core/
COPY Application/Ypdf.CommandLine/. ./Application/Ypdf.CommandLine/

# Publish application
RUN dotnet publish \
    -c Release \
    -f net10.0 \
    -o /app/publish \
    ./Application/Ypdf.CommandLine/Ypdf.CommandLine.csproj

# Use runtime
FROM mcr.microsoft.com/dotnet/runtime:10.0 AS runtime

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        poppler-utils \
        python3 \
        python3-pip \
        python3-venv \
        openjdk-17-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Create final image
WORKDIR /app
COPY --from=build /app/publish ./

# Run application
ENTRYPOINT ["dotnet", "ypdf.dll"]
