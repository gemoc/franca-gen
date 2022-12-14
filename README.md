# franca-gen
Java based protocol generator based on franca IDL


## Usages

The tool is provided as a command line interface (using a standalone jar) and as a maven plugin.

Example of use as maven plugin:
https://github.com/gemoc/franca-gen/blob/main/org.gemoc.franca.protocol.gen.plugin.it.test/src/test/resources/eaopjavagen/pom.xml


## Development


Compiling

```sh
mvn clean install
```

Launch maven plugin test suite:

```
cd org.gemoc.franca.protocol.gen.plugin.it.test
mvn clean verify
```

Manual launch of one of the test suite example

```
cd org.gemoc.franca.protocol.gen.plugin.it.test/src/test/resources/<projectexample>
mvn clean package
```


You can enable more verbose log message with the following parameter `-Dorg.slf4j.simpleLogger.log.org.gemoc=debug`


![maven workflow](https://github.com/gemoc/franca-gen/actions/workflows/maven.yml/badge.svg)


