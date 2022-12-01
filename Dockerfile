# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 8080
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Cyclee.API/Cyclee.API.csproj", "Cyclee.API/"]
COPY ["Cyclee.API.Domain/Cyclee.API.Domain.csproj", "Cyclee.API.Domain/"]
COPY ["Cyclee.API.Infrastructure/Cyclee.API.Infrastructure.csproj", "Cyclee.API.Infrastructure/"]
RUN dotnet restore "Cyclee.API/Cyclee.API.csproj"
COPY . .
WORKDIR "/src/Cyclee.API"
RUN dotnet build "Cyclee.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Cyclee.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cyclee.API.dll"]
