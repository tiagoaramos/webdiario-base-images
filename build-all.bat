@echo off
REM 🚀 WebDiário Base Images - Build Script (Windows)
REM Builds all Docker images in the correct order

setlocal enabledelayedexpansion

echo 🏗️ Building WebDiário Base Images...

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

REM Build base image first
echo [INFO] Building base image...
call :build_image "WebDiário Base" "." "webdiario-base:latest"

REM Build AWS images
echo [INFO] Building AWS images...
call :build_image "WebDiário AWS" "./aws" "webdiario-aws:latest"
call :build_image "WebDiário AWS Java" "./aws/java" "webdiario-aws-java:latest"
call :build_image "WebDiário AWS Java 21" "./aws/java/21" "webdiario-aws-java-21:latest"
call :build_image "WebDiário AWS Node" "./aws/node" "webdiario-aws-node:latest"
call :build_image "WebDiário AWS Node 22.17.1" "./aws/node/22.17.1" "webdiario-aws-node-22.17.1:latest"

REM Build GCP images
echo [INFO] Building GCP images...
call :build_image "WebDiário GCP" "./gcp" "webdiario-gcp:latest"
call :build_image "WebDiário GCP Java" "./gcp/java" "webdiario-gcp-java:latest"
call :build_image "WebDiário GCP Java 21" "./gcp/java/21" "webdiario-gcp-java-21:latest"
call :build_image "WebDiário GCP Node" "./gcp/node" "webdiario-gcp-node:latest"
call :build_image "WebDiário GCP Node 22.17.1" "./gcp/node/22.17.1" "webdiario-gcp-node-22.17.1:latest"

echo [SUCCESS] All images built successfully!

REM List all built images
echo [INFO] Built images:
docker images | findstr webdiario

echo.
echo [SUCCESS] 🎉 WebDiário Base Images build completed!
echo [INFO] You can now use these images in your projects:
echo   - webdiario-base:latest
echo   - webdiario-aws:latest
echo   - webdiario-aws-java:latest
echo   - webdiario-aws-java-21:latest
echo   - webdiario-aws-node:latest
echo   - webdiario-aws-node-22.17.1:latest
echo   - webdiario-gcp:latest
echo   - webdiario-gcp-java:latest
echo   - webdiario-gcp-java-21:latest
echo   - webdiario-gcp-node:latest
echo   - webdiario-gcp-node-22.17.1:latest

pause
