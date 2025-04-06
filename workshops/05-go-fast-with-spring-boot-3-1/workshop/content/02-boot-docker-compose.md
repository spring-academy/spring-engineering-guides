For this lab, we will start with a Spring Boot 3.0 application and upgrade it to Spring Boot 3.1.

```editor:select-matching-text
file: ~/exercises/build.gradle
text: "id 'org.springframework.boot' version"
```

Josh's video doesn't start with a 3.0 application and go through the upgrade process, so the flow will be a bit different here. However, the end content and the message remain the same.

> 🎥 This section roughly tracks Josh's video from **5:04** to **8:14**.

```dashboard:open-dashboard
name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
```

1. Run with Spring Boot 3.0.

   Run the `SpringAcademySampleApplication.java` and you will notice that we have a problem.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/academy/spring/sample/SpringAcademySampleApplication.java
   text: "public static void main(String[] args)"
   description: "Right-click ➡️ Run Java"
   ```

   You'll see that a Terminal window pane opens at the bottom of the Editor window with the following output:

   ```shell
   ...
   ***************************
   APPLICATION FAILED TO START
   ***************************

   Description:

   Failed to configure a DataSource: 'url' attribute is not specified and no embedded datasource could be configured.

   Reason: Failed to determine a suitable driver class


   Action:

   Consider the following:
           If you want an embedded database (H2, HSQL or Derby), please put it on the classpath.
           If you have database settings to be loaded from a particular profile you may need to activate it (no profiles are currently active).
   ```

   This makes sense, as we haven't yet defined a datasource.

   Until Spring Boot 3.1, datasources needed to be managed externally and connected through Spring Boot properties. Since we haven't provided Spring Boot with the information to connect to a datasource, this is the error we would expect to see.

1. Add Docker Compose.

   One way to add an external datasource is by using Docker Compose.

   In Boot 3.0.x, we would need to run the Docker Compose script manually and update an application.properties file with the database url, username, and password.

   Spring Boot 3.1 includes Docker Compose integration, which will look for a configuration file in the current working directory. See the [release notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.1-Release-Notes#docker-compose) for specific information about expected file names and how to customize.

   Create a new `docker-compose.yaml` in the directory root (same level as the `build.gradle` file) with the following data:

   ```editor:append-lines-to-file
   file: ~/exercises/docker-compose.yaml
   description: "Generate an empty docker-compose.yaml"
   ```

   ```yaml
   version: "3"

   services:
     postgres:
       image: postgres:15.2
       environment:
         - POSTGRES_USER=bp
         - POSTGRES_DB=bp
         - POSTGRES_PASSWORD=bp
       ports:
         - "5432:5432"
   ```

   > 🎥 Josh has to manually add docker compose support at **5:18** and mentions that one day [start.spring.io](https://start.spring.io/) will have Docker Compose support. That day is now!
   > To automatically generate the preceding Docker file, add `Docker Compose Support` and `PostgreSQL Driver` as dependencies. You will have a `compose.yaml` file generated for you!

   > 🎥 At **5:32** Josh discusses how this Docker compose file simplifies connecting to the external database with Spring Boot.

   ```dashboard:open-dashboard
   name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
   ```

1. Run the `SpringAcademySampleApplication` again.

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/academy/spring/sample/SpringAcademySampleApplication.java
   text: "public static void main(String[] args)"
   description: "Right-click ➡️ Run Java"
   ```

   ```shell
   ...
   ***************************
   APPLICATION FAILED TO START
   ***************************

   Description:

   Failed to configure a DataSource: 'url' attribute is not specified and no embedded datasource could be configured.
   ...
   ```

   Note that, even though we have a `docker-compose.yml` file in our project root, our application still fails with the same error message. This is because we are still running on the 3.0 line, and Spring Boot 3.0 is not able to load this configuration

1. Upgrade to Spring Boot 3.1.

   Let's see if we can get our code working by changing only the Spring Boot version in the `build.gradle`.

   - Change the version of Spring Boot to 3.1.10:

     ```editor:select-matching-text
     file: ~/exercises/build.gradle
     text: "id 'org.springframework.boot'"
     ```

     ```groovy
     plugins {
       id 'java'
       id 'org.springframework.boot' version '3.1.10'
       id 'io.spring.dependency-management' version '1.1.0'
     }
     ```

   - Add new dependencies:

     ```editor:select-matching-text
     file: ~/exercises/build.gradle
     text: "dependencies"
     ```

     ```groovy
     developmentOnly 'org.springframework.boot:spring-boot-docker-compose'
     developmentOnly 'org.springframework.boot:spring-boot-devtools'
     ```

   - There are a few lines in the `build.gradle` for the `testcontainers` dependency in 3.0.x. Remove these lines:

     Remove the entire `ext{...}` section:

     ```editor:select-matching-text
     file: ~/exercises/build.gradle
     text: "ext {"
     after: 2
     ```

     ```groovy
     // Remove the below lines
     ext {
       set('testcontainersVersion', "1.18.1")
     }
     ```

     Remove the entire `dependencyManagement` section, too.

     ```editor:select-matching-text
     file: ~/exercises/build.gradle
     text: "dependencyManagement"
     after: 4
     ```

     ```groovy
     // Remove the below lines, too
     dependencyManagement {
     	imports {
     	  mavenBom "org.testcontainers:testcontainers-bom:${testcontainersVersion}"
     	}
     }
     ```

1. Success!

   Let's run the application again:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/academy/spring/sample/SpringAcademySampleApplication.java
   text: "public static void main(String[] args)"
   description: "Right-click ➡️ Run Java"
   ```

   Note how with no code changes the application now executes our Docker Compose configuration. You should observe something like this in the output:

   ```shell
   2023-05-18T17:31:28.221Z  INFO 11372 --- [utReader-stderr] o.s.boot.docker.compose.core.DockerCli   :  Container exercises-postgres-1  Creating
   2023-05-18T17:31:28.339Z  INFO 11372 --- [utReader-stderr] o.s.boot.docker.compose.core.DockerCli   :  Container exercises-postgres-1  Created
   2023-05-18T17:31:28.340Z  INFO 11372 --- [utReader-stderr] o.s.boot.docker.compose.core.DockerCli   :  Container exercises-postgres-1  Starting
   2023-05-18T17:31:28.592Z  INFO 11372 --- [utReader-stderr] o.s.boot.docker.compose.core.DockerCli   :  Container exercises-postgres-1  Started
   2023-05-18T17:31:28.592Z  INFO 11372 --- [utReader-stderr] o.s.boot.docker.compose.core.DockerCli   :  Container exercises-postgres-1  Waiting
   2023-05-18T17:31:29.095Z  INFO 11372 --- [utReader-stderr] o.s.boot.docker.compose.core.DockerCli   :  Container exercises-postgres-1  Healthy
   ```

   You can now access the endpoint by executing this command on the Terminal:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ curl http://localhost:8080/customers | jq
   ```

   Here is the output, formatted for your convenience:

   ```json
   [
     { "id": 1, "name": "Phil" },
     { "id": 2, "name": "Andy" },
     { "id": 3, "name": "Madhura" },
     { "id": 4, "name": "Olga" },
     { "id": 5, "name": "Violeta" },
     { "id": 6, "name": "Yuxin" },
     { "id": 7, "name": "Dr. Syer" },
     { "id": 8, "name": "Stéphane" },
     { "id": 9, "name": "Jürgen" },
     { "id": 10, "name": "Josh" }
   ]
   ```

1. Explanation.

   Spring Boot did two things here that are important to call out.

   First, Spring Boot automatically found the `docker-compose.yaml` file and started the containers. We saw this by inspecting the console and viewing the healthy containers.

   Second, Spring Boot accepted the environment variables from `docker-compose.yaml`. This is why we did not have to specify anything additional in the `application.properties` file, as we normally would.

   > 🎥 At **10:06**, Josh explains this new indirection that lets Spring Boot pick up the properties from the `docker-compose.yaml`.

   ```dashboard:open-dashboard
   name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
   ```
