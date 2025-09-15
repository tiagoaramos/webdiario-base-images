@echo off
REM 🚀 WebDiário Base Images Alpine - Build Script (Windows)
REM Builds all Alpine Docker images in the correct order

setlocal enabledelayedexpansion

echo 🏗️ Building WebDiário Base Images Alpine...

REM Function to build image
:build_image
set image_name=%1
set dockerfile_path=%2
set tag=%3

echo [INFO] Building %image_name% from %dockerfile_path%...

docker build -t %tag% %dockerfile_path%
if %errorlevel% neq 0 (
    echo [ERROR] Failed to build %image_name%
    exit /b 1
)

echo [SUCCESS] Successfully built %image_name%
goto :eof

REM Build Alpine base image first
echo [INFO] Building Alpine base image...
call :build_image "WebDiário Base Alpine" "./alpine" "webdiario-base-alpine:latest"

REM Build AWS Alpine images
echo [INFO] Building AWS Alpine images...
call :build_image "WebDiário AWS Alpine" "./alpine/aws" "webdiario-aws-alpine:latest"
call :build_image "WebDiário AWS Java Alpine" "./alpine/aws/java" "webdiario-aws-java-alpine:latest"
call :build_image "WebDiário AWS Java 21 Alpine" "./alpine/aws/java/21" "webdiario-aws-java-21-alpine:latest"
call :build_image "WebDiário AWS Node Alpine" "./alpine/aws/node" "webdiario-aws-node-alpine:latest"
call :build_image "WebDiário AWS Node 22.17.1 Alpine" "./alpine/aws/node/22.17.1" "webdiario-aws-node-22.17.1-alpine:latest"

REM Build GCP Alpine images
echo [INFO] Building GCP Alpine images...
call :build_image "WebDiário GCP Alpine" "./alpine/gcp" "webdiario-gcp-alpine:latest"
call :build_image "WebDiário GCP Java Alpine" "./alpine/gcp/java" "webdiario-gcp-java-alpine:latest"
call :build_image "WebDiário GCP Java 21 Alpine" "./alpine/gcp/java/21" "webdiario-gcp-java-21-alpine:latest"
call :build_image "WebDiário GCP Node Alpine" "./alpine/gcp/node" "webdiario-gcp-node-alpine:latest"
call :build_image "WebDiário GCP Node 22.17.1 Alpine" "./alpine/gcp/node/22.17.1" "webdiario-gcp-node-22.17.1-alpine:latest"

echo [SUCCESS] All Alpine images built successfully!

REM List all built Alpine images
echo [INFO] Built Alpine images:
docker images | findstr webdiario | findstr alpine

echo.
echo [SUCCESS] 🎉 WebDiário Base Images Alpine build completed!
echo [INFO] You can now use these Alpine images in your projects:
echo   - webdiario-base-alpine:latest
echo   - webdiario-aws-alpine:latest
echo   - webdiario-aws-java-alpine:latest
echo   - webdiario-aws-java-21-alpine:latest
echo   - webdiario-aws-node-alpine:latest
echo   - webdiario-aws-node-22.17.1-alpine:latest
echo   - webdiario-gcp-alpine:latest
echo   - webdiario-gcp-java-alpine:latest
echo   - webdiario-gcp-java-21-alpine:latest
echo   - webdiario-gcp-node-alpine:latest
echo   - webdiario-gcp-node-22.17.1-alpine:latest

pause
