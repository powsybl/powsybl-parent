# PowSyBl Parent

[![MPL-2.0 License](https://img.shields.io/badge/license-MPL_2.0-blue.svg)](https://www.mozilla.org/en-US/MPL/2.0/)
[![Slack](https://img.shields.io/badge/slack-powsybl-blueviolet.svg?logo=slack)](https://join.slack.com/t/powsybl/shared_invite/zt-rzvbuzjk-nxi0boim1RKPS5PjieI0rA)

PowSyBl (**Pow**er **Sy**stem **Bl**ocks) is an open source framework written in Java, that makes it easy to write complex
software for power systems’ simulations and analysis. Its modular approach allows developers to extend or customize its
features.

PowSyBl is part of the LF Energy Foundation, a project of The Linux Foundation that supports open source innovation projects
within the energy and electricity sectors.

<p align="center">
<img src="https://raw.githubusercontent.com/powsybl/powsybl-gse/main/gse-spi/src/main/resources/images/logo_lfe_powsybl.svg?sanitize=true" alt="PowSyBl Logo" width="50%"/>
</p>

Read more at https://www.powsybl.org !

This project and everyone participating in it is governed by the [PowSyBl Code of Conduct](https://github.com/powsybl/.github/blob/main/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior to [powsybl-tsc@lists.lfenergy.org](mailto:powsybl-tsc@lists.lfenergy.org).

## PowSyBl vs PowSyBl Parent

This contains parent poms for powsybl projects. The parent poms will add standard powsybl build possibilities. 

### Plain java projects 
For normal projects, use powsybl-parent. It provides:

- default values for the project url, the license, the source encoding, the developpers
- versions of maven plugins used by our build system
- a default target java version (8)
- automatic checks (maven version + checkstyle), that can be disabled on the command line (-P'-checks' or -Dpowsybl.checks.skip=true)
- a -Prelease profile that activates plugins to upload to ossrh (signing, javadoc, source jar)
- a -Pjacoco enabling jacoco
- PluginManagement for various plugins, this means that they are enabled only if you repeat them in the <build><plugins> section of your pom : maven-templating-plugin (filter-src), maven-failsafe-plugin (integration-test, verify), maven-plugin-plugin (process-class, utilisé par itools-packager uniquement..), maven-shade-plugin
- an optional recommended lombok configuration: to activate it, create an empty file `.mvn/lombok-config-copy.marker`, and make sure that the file `lombok.config` at the root of the project exists and contains the following as the first line:
  ```
  import target/configs/powsybl-build-tools.jar!powsybl-build-tools/lombok.config
  ```
  Note: If you created the marker file, there is a check during the build that the first line of lombok.config is correct. If needed, it can be disabled with `-P'!check-lombok'`.

### WebService java projects
Additionally, a powsybl-parent-ws using spring and jib is available. It provides
- spring-boot-maven-plugin and jib-maven-plugin and git-commit-id-plugin versions
- pluginmanagement for these plugins that you must include in your spring-boot module
- automatic spring fat-jar generation (can be disabled with -Dpowsybl.spring-boot.skip=true)
- profiles for generating docker images that can be enabled on the command line, bound to their respective maven phase: [docker usage](#docker-usage) 
- default configuration of liquibase-maven-plugin that works with jpa annotations (using hibernate): [liquibase usage](#liquibase-usage) 

#### Docker usage
- -Dpowsybl.docker.package : build a .tar file in target containing the image
- -Dpowsybl.docker.install : install the image to the docker daemon (requires a docker daemon). This has the advantage of not storing the base image everytime and saves a lot of disk space (hundreds of MBs depending on the image)
- -Dpowsybl.docker.deploy : deploy the docker image to a docker registry
- default configuration mimicking spring-boot-starter-parent for default plugins (maven-compiler-plugin, maven-resource-plugin)

#### Liquibase usage
To use liquibase, you must first:
- set the maven property 'liquibase-hibernate-package' in your pom.xml to the root package containing your entities
- create a folder in src/main/resources/db/changelog/changesets, generated changesets will be written there.

Then, you can do one of the following:
##### Creating changesets
The most common operation is to generate a new changeSet corresponding to the differences between the existing changesets, and the jpa annotation in the source code. Use this command when you have created or modified your jpa annotations.
  ```
  mvn clean compile liquibase:update liquibase:diff -Dpowsybl.liquibase.generate
  ```
Note1: for the very first changeset in a projet, omit the "liquibase:update" part of the command line

Note2: you must manually add the generated file to the listing in src/main/resources/db/changelog/db.changelog-master.yaml. It will look like this:
```
databaseChangeLog:
  - include:
      file: changesets/changelog_2021-03-21T11:37:57Z.xml
      relativeToChangelogFile: true
  - include:
      file: changesets/changelog_2022-14-13T23:21:49Z.xml
      relativeToChangelogFile: true
  # ... more files
```
##### Inspecting the schema
Another possibility is to dump the sql statements corresponding to the jpa annotations:
  ```
  mvn compile liquibase:dropAll liquibase:diff -Dliquibase-diff.outputFile=out.DATABASE_TYPE.sql
  ```

Another possibility is to dump the sql statements corresponding to the existing changesets:
  ```
  mvn clean liquibase:update liquibase:generateChangeLog -Dliquibase.outputChangeLogFile=out.DATABASE_TYPE.sql
  ```

Note: Replace DATABASE_TYPE by your database vendor. To get a list of supported types, execute the command as is.
