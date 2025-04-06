Welcome to the Spring Academy Lab for "What's New in Spring Boot 3.2."

While the [release notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.2-Release-Notes) describe the many new features, we dive deeper into a few specific ones in the following lab:

- [`RestClient`](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.2-Release-Notes#restclient-support)
- [`JdbcClient`](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.2-Release-Notes#support-for-jdbcclient)
- [Virtual Threads](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.2-Release-Notes#support-for-virtual-threads)

In this short lab, you can get the chance to work hands-on with the new Spring Boot 3.2 features. You can experiment entirely in the browser, and no changes are made to your local machine.

This lab frequently references external resources for deeper learning on each topic. The lab sections walk you through some base cases. It is up to you how deep you want to go with the supplemental material.

## Start Your Apps

This lab uses [Spring Boot DevTools](https://docs.spring.io/spring-boot/docs/current/reference/html/using.html#using.running-your-application.hot-swapping) for automatic reloading of our applications as you write code. You need only save the file you are working in, and Spring automatically recompiles and redeploys your application. This means that you can start your applications now:

▶️ Start `sample-sever` (running on port 8081)

```editor:select-matching-text
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/ServerApplication.java
text: "public static void main(String[] args)"
description: "Right-click ➡️ Run Java"
```

▶️ Start `sample-client` (running on port 8080)

```editor:select-matching-text
file: ~/exercises/sample-client/src/main/java/academy/spring/sample/client/ClientApplication.java
text: "public static void main"
description: "Right-click ➡️ Run Java"
```

## Jump Around

You can complete the three lessons in this lab independently and in any order. The sections are separated by packages in the `sample-server` application to ensure the code is isolated.
