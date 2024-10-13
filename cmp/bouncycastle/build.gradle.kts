plugins {
    id("java")
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.bouncycastle:bcprov-jdk18on:1.73")
    implementation("org.bouncycastle:bcpkix-jdk18on:1.73")
    implementation("net.sourceforge.argparse4j:argparse4j:0.9.0")
}
