With Spring Boot 3.1, we can now use TestContainers to handle the database dependency at development time.

Note that all of the code we are about to write is in the `src/test` folder and won't be packaged in our production code.

> 🎥 This section tracks from **10:58** to **16:18**.

```dashboard:open-dashboard
name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
```

1. Clean up.

   To prepare for the next lab sections, let's undo the changes that we just made:

   - Stop the running application.
   - Delete `docker-compose.yml`.

   ```editor:open-file
   file: ~/exercises/docker-compose.yaml
   ```

   - Remove the `spring-boot-docker-compose` dependency from `build.gradle`.

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "developmentOnly 'org.springframework.boot:spring-boot-docker-compose'"
   ```

1. Import the Spring Boot TestContainers Dependency.

   First, we will need to add the `spring-boot-testcontainers` dependency to `build.gradle`:

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "dependencies"
   ```

   ```groovy
   testImplementation 'org.springframework.boot:spring-boot-testcontainers'
   ```

1. Use TestContainers at Development Time.

   Now we will build the new test class one step at a time. Jump to the end of this section if you want to see only the final product.

   - Create a new test class: `src/test/java/academy/spring/sample/TestDemoApplication.java`.

     ```editor:append-lines-to-file
     file: ~/exercises/src/test/java/academy/spring/sample/TestDemoApplication.java
     description: "Generate the TestDemoApplicaiton.java file"
     ```

   - Add the `package` and `import` statements that we will use as we create our class so that we don't get compilation errors as we go:

     ```java
     package academy.spring.sample;

     import org.testcontainers.containers.PostgreSQLContainer;
     import org.springframework.boot.SpringApplication;
     import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
     import org.springframework.context.annotation.Bean;
     import org.springframework.context.annotation.Configuration;
     ```

   - Add the class definition and configuration annotation:

     ```java
     @Configuration
     public class TestDemoApplication {

     }
     ```

   - Add a new main method in the test class.

     This will delegate to our `SpringAcademySampleApplication` class but augment it with configuration in this class:

     ```java
     public static void main(String[] args) {
         SpringApplication
                 .from(SpringAcademySampleApplication::main)
                 .with(TestDemoApplication.class)
                 .run(args);
     }
     ```

   - Add the test container:

     ```java
     @Bean
     @ServiceConnection
     PostgreSQLContainer postgreSQLContainer () {
         return new PostgreSQLContainer("postgres:15.1-alpine");
     }
     ```

   Finally, the whole test class should look like this:

   ```java
   package academy.spring.sample;

   import org.testcontainers.containers.PostgreSQLContainer;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
   import org.springframework.context.annotation.Bean;
   import org.springframework.context.annotation.Configuration;

   @Configuration
   public class TestDemoApplication {

   	@Bean
   	@ServiceConnection
   	PostgreSQLContainer postgreSQLContainer () {
   		return new PostgreSQLContainer("postgres:15.1-alpine");
   	}

   	public static void main(String[] args) {
   		SpringApplication
   				.from(SpringAcademySampleApplication::main)
   				.with(TestDemoApplication.class)
   				.run(args);
   	}
   }
   ```

1. Run with TestContainers at Development Time.

   Run the main method in the newly created `TestDemoApplication`.

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/academy/spring/sample/TestDemoApplication.java
   text: "public static void main(String[] args)"
   description: "Right-click ➡️ Run Java"
   ```

   Observe how the Editor TERMINAL logs use TestContainers, as indicated by `tc` in the `tc.postgres:15.1-alpine` log line:

   ```shell
   2023-05-18T18:33:22.846Z  INFO 9373 --- [  restartedMain] tc.postgres:15.1-alpine                  : Container postgres:15.1-alpine started in PT1.722827516S
   ```

   The Spring Boot application is now running with a TestContainers database.

   You can now access the endpoint by using this command on the terminal:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ curl http://localhost:8080/customers | jq
   ```

   And you should see some output like the following:

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

1. Restart Scope.

   In the previous section, we started a TestContainer and used it at development time. But what if we want the TestContainer we're using to endure longer than every restart? We shouldn't need to restart the container every time.

   We can use the `@RestartScope` annotation for this.

   > 🎥 Josh covers this starting at **13:23** in the video.

   ```dashboard:open-dashboard
   name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
   ```

   In order to better observe the benefit of `@RestartScope`, you can insert a new log statement anywhere in `CustomerHttpController`. Note the log lines produced as the application launches. You should see the container starting again, indicated by the line `Container postgres:15.1-alpine is starting`. The application restart should take approximately 1.5 seconds.

1. Add a Gradle dependency.

   To use the `@RestartScope` annotation, we first need to bring in the correct dependency.

   Open `build.gradle` and change the scope of the `spring-boot-devtools` dependency from `developmentOnly` to `testImplementation`:

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "developmentOnly 'org.springframework.boot:spring-boot-devtools'"
   ```

   ```groovy
   // change developmentOnly to testImplementation
   testImplementation 'org.springframework.boot:spring-boot-devtools'
   ```

1. Add `@RestartScope`.

   Now that we have the devtools dependency, we can add `@RestartScope` to our TestContainer.

   Open `TestDemoApplication`, add a new import, and annotate the Bean:

   ```editor:select-matching-text
   file: ~/exercises/src/test/java/academy/spring/sample/TestDemoApplication.java
   text: "PostgreSQLContainer postgreSQLContainer ()"
   ```

   Add the import:

   ```java
   import org.springframework.boot.devtools.restart.RestartScope;
   ```

   Annotate the `PostgreSQLContainer` Bean with the following:

   ```java
   @RestartScope
   ```

   So that the Bean definition now looks like

   ```java
   @Bean
   @RestartScope
   @ServiceConnection
   PostgreSQLContainer postgreSQLContainer () {
       return new PostgreSQLContainer("postgres:15.1-alpine");
   }
   ```

   One way to observe `@RestartScope` in action is to add another log line in our `CustomerHttpController`, as we did in an earlier step.

   Notice that since the container is annotated with `@RestartScope` we do not see the log line about the Postgres container starting. The benefit can also be observed by a decreased restart time.

   We should see approximately a 0.2 second restart time as compared to the 1.5 second restart time without the annotation.

1. Dev Tools Review.

   Note that, while we demonstrated the new Dev Tools functionality initially using Docker Compose support, it works great with TestContainers as well!

   As we edited our `TestDemoApplication.java` file, we saw the Editor TERMINAL pane that our changes are automatically loading!

   > 🎥 Check out **14:50** in the video for another example of how Dev Tools increases developer productivity!
   >
   > "TestContainers is my favorite permutation of this support. Docker Compose works amazingly well, so does test containers, but paired with the 1-2 punch of Dev Tools and smart lifecycle support, you can now take some code that you've got in your organization, Git clone it, load it into the IDE, hit start, you now have all the Docker instances, all the containers you need to run the system up and running with the application."

   ```dashboard:open-dashboard
   name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
   ```

1. GraalVM.

   In the final minutes of Josh's video (🎥 starting at 16:27), he covers native image compilation. While we won't cover native images in this lab, be sure to check out Spring Academy's course on [Building Native Applications with Spring Boot and GrallVM](https://spring.academy/courses/spring-boot-native).

## Conclusion

In this lab you learned about how Spring Boot 3.1 increases developer productivity. Be sure to check out [Spring Academy's course on Native Applications](https://spring.academy/courses/spring-boot-native) as well to learn more about machine productivity.
