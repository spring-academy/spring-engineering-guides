+++
title="Lab Overview"
+++

Spring AI is an application framework for AI engineering. Its goal is to apply Spring ecosystem design principles to the AI domain. These principles include portability, modular design, and promoting the use of POJOs as the building blocks of an application.

Spring AI provides portable API support across AI providers for chat, text-to-image, and embedding models. Both synchronous and stream API options are supported. Accessing model-specific features is also supported.

{{< note >}}
You must complete the following two steps before continuing the lab.
{{< /note >}}

## OpenAI API Key

While many different vendors are supported, this lab uses [OpenAI](https://openai.com/) to demonstrate the capabilities of [Spring AI](https://spring.io/projects/spring-ai).

A prerequisite to completing this guide is to obtain your own personal API key from [OpenAI](https://openai.com/).

This lab environment is not stored, so you can add your API key in plain text to `application.properties`. Note that, while this is acceptable for this short tutorial, you should consider an alternate approach when working outside of this environment.

One such approach is setting a system variable and referencing that from `application.properties`. This also gives you the ability to easily swap keys or use the system variable in other locations.

When you have your API key, replace `${OPENAI_API_KEY}` in the `application.properties` file with your information.

```editor:select-matching-text
file: ~/exercises/src/main/resources/application.properties
text: "${OPENAI_API_KEY}"
description: "Replace ${OPENAI_API_KEY} with your key"
```

## Dev Tools

In this lab, you use [Spring Boot DevTools](https://docs.spring.io/spring-boot/docs/3.2.0/reference/html/using.html#using.devtools) to automatically deploy the application each time you save your work. This means that you need only start the application once and need not worry about continually stopping and restarting as you make changes.

**▶️ Start the application now**

```editor:select-matching-text
file: ~/exercises/src/main/java/academy/spring/springai/songs/SongsApplication.java
text: "public static void main(String[] args)"
description: "Right-click ➡️ Run Java"
```
