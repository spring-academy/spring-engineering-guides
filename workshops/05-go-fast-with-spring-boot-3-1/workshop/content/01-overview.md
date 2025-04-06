Welcome to the Spring Academy Guide to Josh Long's video [_Spring Tips: go fast with Spring Boot 3.1_](https://youtu.be/ykEK2xuJrN8).

This hands-on lab environment is designed with Josh's video in a way that will require no changes to your local machine.

We suggest that you use the embedded video on this page next to the "Editor" and "Terminal" tabs to easily follow along:

```dashboard:open-dashboard
name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
```

We will reiterate some of Josh's points in text but will also defer to the video for further reference.

## Application Overview

We won't spend a lot of time discussing the internals of the application used in this Guide, but it is worth inspecting the `SpringAcademySampleApplication` class.

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/sample/SpringAcademySampleApplication.java
text: "public class SpringAcademySampleApplication"
```

In short, this sample application will:

- Use SpringData JDBC to communicate with a SQL database.
- Create an HTTP Endpoint to expose the data.

To learn about these topics in more detail, see the [Build a REST API with Spring Boot](https://spring.academy/courses/building-a-rest-api-with-spring-boot) course.

> 🎥 Josh covers this material from **4:06** to **5:03**.

```dashboard:open-dashboard
name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
```

## Data Overview

The application will automatically create a database table and load in sample data.

This is accomplished by `data.sql` and `schema.sql` files. These are provided to you but worth inspecting to understand the data that we are working with.

```editor:open-file
file: ~/exercises/src/main/resources/schema.sql
```

```editor:open-file
file: ~/exercises/src/main/resources/data.sql
```

> 🎥 Josh covers this material from **6:49** to **7:46**.

```dashboard:open-dashboard
name: "🎥 Video - Spring Tips - go fast with Spring Boot 3-1"
```

### Spring Version

This lab is loaded using a release from the Spring Boot 3.0 line. We will upgrade this to Spring Boot 3.1 as part of this lab.

```editor:select-matching-text
file: ~/exercises/build.gradle
text: "id 'org.springframework.boot' version"
```
