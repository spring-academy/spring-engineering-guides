STOP both applications in the Editor. You can do this by switching to the Editor tab and either:

- Clicking the "STOP" buttons at the top of the Editor tab
- Clicking the trash-bin icons 🗑️ in the TERMINAL pane at the bottom of the Editor tab

```dashboard:open-dashboard
name: Editor
```

Instead, you will run the commands from the Terminal. This is for two reasons.

First, you are going to change the `pom.xml` file, which requires the editor to re-sync the files. This is another step for the IDE to perform and can be error prone, so you should use the Terminal to eliminate that dependency.

Second, you are going to view log line output. That is easier if you do not have to switch tabs.

## Upgrade to JDK21

To demonstrate support for virtual threads in Spring Boot 3.2, we first need to upgrade to JDK 21. SDKman is already installed and can be used to download JDK 21 with the following command. (This could take a minute.)

```execute
sdk install java 21.0.1-librca
```

```execute
bash
```

Verify that Java is running JDK 21:

```execute
java -version
```

```shell
[~/exercises] $ java -version
openjdk version "21.0.1" 2023-10-17 LTS
OpenJDK Runtime Environment (build 21.0.1+12-LTS)
OpenJDK 64-Bit Server VM (build 21.0.1+12-LTS, mixed mode)
```

## Virtual Thread Support

Spring Boot 3.2 introduced support for virtual threads. If you are not familiar with the concept, [Dan Vega provides an overview of virtual threads in this YouTube video](https://www.youtube.com/watch?v=THavIYnlwck). This section takes some code from the video, but we do not go through the same performance-testing exercise.

## Observe Provided Code

The `sample-server` module shows how Spring Boot 3.2 uses virtual threads. Take a moment to investigate the `BlockController` in the `sample-server` module that exposes an endpoint that performs `Thread.sleep` for a number of seconds. The method also prints out the current thread on which the request runs.

```editor:select-matching-text
file: ~/exercises/sample-server/src/main/java/academy/spring/sample/server/virtualthreads/BlockController.java
text: "Thread.sleep(seconds * 1000);"
```

### Platform Threads Request

At this point, you have installed JDK 21, but your Spring Boot application still uses Java 17. Now start the `sample-server` application:

```execute-1
cd sample-server
```

```execute-1
./mvnw clean package spring-boot:run
```

Now that the `server-application` is running on port 8081, send a request to your `BlockController`.

```execute-2
http :8081/block/3
```

After **three seconds**, the request should return.

Now, in the Terminal pane running the application, you can see a log statement similar to the following entry:

```shell
0000-00-00T00:00:00.000Z  INFO 1717 --- [sample-server] [nio-8081-exec-1] a.s.s.s.virtualthreads.BlockController   : Running on thread: Thread[#38,http-nio-8081-exec-1,5,main]
```

This tells you that you are using a platform thread.

Next, you can see how easy it is to switch to virtual threads by using Spring Boot 3.2 and Java 21.

Stop the Spring Boot application now. To do so, press `Ctrl + C` in the Terminal pane running the application.

## Use Virtual Threads

The first thing to do is change the Java version in our `pom.xml` from 17 to 21:

```editor:select-matching-text
file: ~/exercises/sample-server/pom.xml
text: "<java.version>17</java.version>"
description: "Update the Java version to 21"
```

```xml
<properties>
	<!-- update from 17 to 21 -->
	<java.version>21</java.version>
</properties>
```

By default, Spring Boot 3.2 still continues to use platform threads until you request otherwise. Fortunately, you can do so can by setting a single property in the `application.properties` file:

```editor:open-file
file: ~/exercises/sample-server/src/main/resources/application.properties
```

Add the following property:

```
spring.threads.virtual.enabled=true
```

This is all that is needed to switch to virtual threads.

Now, start the `ServerApplication` again:

```execute-1
./mvnw clean package spring-boot:run
```

When the application is running, you can send the same request as you previously sent:

```execute-2
http :8081/block/3
```

The difference is in the log files. You should now see something like the following entry in the Terminal pane running the application:

```shell
0000-00-00T00:00:00.000Z  INFO 6000 --- [sample-server] [omcat-handler-0] a.s.s.s.virtualthreads.BlockController   : Running on thread: VirtualThread[#41,tomcat-handler-0]/runnable@ForkJoinPool-1-worker-2
```

In your first request using platform threads, you should have observed `Running on thread: Thread[http-nio-8081-exec-1`.

After switching to virtual threads, you should have seen `Running on thread: VirtualThread`.

## Summary

Why you want to use virtual threads is a topic beyond this lab. Make sure that you are choosing the right architectural style for your application. The point here is that, if you do choose to use virtual threads, Spring Boot 3.2 makes it easy.
