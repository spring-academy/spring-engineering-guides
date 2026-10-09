To improve developer productivity, we can use Spring Boot devtools.

Before continuing, verify that your application is still running by using the `docker-compose.yaml` specification from the previous lab section. We will see how Spring Boot will quickly load changes by only compiling the code.

> 🎥 This section roughly tracks from **8:13** to **10:00**.

```dashboard:open-dashboard
name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
```

1. Inspect Dependencies.

   Verify that `spring-boot-devtools` is in the `build.gradle` dependency section.

   ```editor:select-matching-text
   file: ~/exercises/build.gradle
   text: "developmentOnly 'org.springframework.boot:spring-boot-devtools'"
   ```

1. Test the Missing Endpoint.

   Open the Terminal and try to hit our new endpoint to prove that it will not work:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ curl http://localhost:8080/customers/Josh | jq
   ```

   Verify that you received a `404` error response:

   ```json
   {
     "timestamp": "2023-06-07T21:32:47.950+00:00",
     "status": 404,
     "error": "Not Found",
     "message": "No message available",
     "path": "/customers/Josh"
   }
   ```

1. Add Endpoint.

   To demonstrate the ability to reload changes, we will add an additional endpoint to `CustomerHttpController`:

   ```editor:select-matching-text
   file: ~/exercises/src/main/java/academy/spring/sample/SpringAcademySampleApplication.java
   text: "class CustomerHttpController"
   ```

   Add the following endpoint (while the application is still running):

   ```java
   @GetMapping("/customers/{name}")
   Iterable<Customer> byName(@PathVariable String name) {
       System.out.println("getting a record by name: [" + name + "]!!!!");
       return this.customerRepository.findByName(name);
   }
   ```

1. Recompile by saving the file.

   When you save the file, you will notice in the Editor's terminal that the Spring Boot automatically restarts, with output at the bottom of the has a line similar to this:

   ```shell
   2023-05-23T13:28:13.009Z  INFO 6000 --- [  restartedMain] a.s.s.SpringAcademySampleApplication     : Started SpringAcademySampleApplication in 0.362 seconds (process running for 271.438)
   ```

   Go ahead and save the file a few times and watch the application automatically restart!

1. Test the New Endpoint.

   Open the unused Terminal, run the same command that we ran earlier:

   ```dashboard:open-dashboard
   name: Terminal
   ```

   ```shell
   [~/exercises] $ curl http://localhost:8080/customers/Josh | jq
   [
     {
       "id": 40,
       "name": "Josh"
     }
   ]
   ```

   Notice that this time it works without manually stopping and restarting our application!
