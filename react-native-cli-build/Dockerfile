FROM node:18

# Set up the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    unzip

# Install OpenJDK
RUN mkdir -p /opt/java && \
    curl -L -o openjdk.tar.gz https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz && \
    tar -xzf openjdk.tar.gz -C /opt/java && \
    rm openjdk.tar.gz
ENV JAVA_HOME=/opt/java/jdk-11.0.12+7

RUN ls -l /opt/java/jdk-11.0.12+7

# Download and install Android SDK
ENV ANDROID_HOME /opt/android-sdk
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \
    unzip -qq android-sdk.zip -d ${ANDROID_HOME} && \
    rm -f android-sdk.zip
ENV PATH ${PATH}:${JAVA_HOME}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/bin

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses --sdk_root=${ANDROID_HOME}

# Install React Native CLI globally
RUN npm install -g react-native-cli

# Expose the default React Native development port
EXPOSE 8081

# Start the React Native packager when the container launches
CMD ["npm", "start"]

#docker run --rm -it --name react-project -p 8081:8081 -v "$(pwd)":/app react-native-cli
