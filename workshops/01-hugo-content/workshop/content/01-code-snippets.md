+++
title = 'Code Snippets'
+++

## Shell

`shell`

```shell
[~/exercises] $ ./gradlew test
...
CashCardJsonTest > cashCardSerializationTest() FAILED
    java.lang.IllegalStateException: Unable to load JSON from class path resource [example/cashcard/expected.json]
...
        at example.cashcard.CashCardJsonTest.cashCardSerializationTest(CashCardJsonTest.java:21)

        Caused by:
        java.io.FileNotFoundException: class path resource [example/cashcard/expected.json] cannot be opened because it does not exist
...
2 tests completed, 1 failed

> Task :test FAILED
```

## Java

`java`

```java
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class CashCardApplicationTests {
    @Autowired
    TestRestTemplate restTemplate;

    // comment here

    @Test
    void shouldReturnACashCardWhenDataIsSaved() {
        ResponseEntity<String> response = restTemplate.getForEntity("/cashcards/99", String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }
}
```

## YAML

`yaml`

```yaml
spec:
  applications:
  session:
    docker:
    enabled: true
    storage: 500Mi
    socket:
      # you must have this to enable docker ps, etc.
      enabled: true
```

## Groovy

`groovy`

Used in `build.gradle` files.

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-security'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher' // See https://docs.gradle.org/8.3/userguide/upgrading_version_8.html#test_framework_implementation_dependencies
```

## SQL

`sql`

```sql
SELECT * FROM users WHERE name="sarah1";
```

## Markdown

`markdown`

```markdown

## This is a heading

Paragraph text.

- bullet 1
- bullet 2

1. first number one
1. next number
```

## PHP

`php`

```php
<?php

namespace App\Models\Pivots;

use App\Models\Course;
use Illuminate\Database\Eloquent\Relations\Pivot;

class RelatedCourse extends Pivot
{
    /**
     * Eloquent
     */
    protected $table = 'related_courses';

    /**
     * Relationships
     */
    public function course()
    {
        return $this->belongsTo(Course::class);
    }

    public function related()
    {
        return $this->belongsTo(Course::class, 'related_id');
    }
}
```

