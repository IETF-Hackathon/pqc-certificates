plugins {
    id("java")
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
//    testImplementation(platform("org.junit:junit-bom:5.9.1"))
//    testImplementation("org.junit.jupiter:junit-jupiter")
    implementation("org.bouncycastle:bcprov-jdk18on:1.73")
    implementation("org.bouncycastle:bcpkix-jdk18on:1.73")
}

tasks.test {
    useJUnitPlatform()
}