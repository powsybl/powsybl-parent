# PowSyBl Parent

[![MPL-2.0 License](https://img.shields.io/badge/license-MPL_2.0-blue.svg)](https://www.mozilla.org/en-US/MPL/2.0/)
[![Join the community on Spectrum](https://withspectrum.github.io/badge/badge.svg)](https://spectrum.chat/powsybl)

PowSyBl (**Pow**er **Sy**stem **Bl**ocks) is an open source framework written in Java, that makes it easy to write complex
software for power systems’ simulations and analysis. Its modular approach allows developers to extend or customize its
features.

PowSyBl is part of the LF Energy Foundation, a project of The Linux Foundation that supports open source innovation projects
within the energy and electricity sectors.

<p align="center">
<img src="https://raw.githubusercontent.com/powsybl/powsybl-gse/master/gse-spi/src/main/resources/images/logo_lfe_powsybl.svg?sanitize=true" alt="PowSyBl Logo" width="50%"/>
</p>

Read more at https://www.powsybl.org !

This project and everyone participating in it is governed by the [PowSyBl Code of Conduct](https://github.com/powsybl/.github/blob/master/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior to [powsybl-tsc@lists.lfenergy.org](mailto:powsybl-tsc@lists.lfenergy.org).

## PowSyBl vs PowSyBl Parent

This contains parent poms for powsybl projects. The parent poms will add standard powsybl build possibilities. For normal projects, use powsybl-parent. It provides:

- default values for the project url, the license, the source encoding, the developpers
- versions of maven plugins used by our build system
- a default target java version (8)
- automatic checks (maven version + checkstyle), that can be disabled on the command line (-P'-checks' or -Dpowsybl.checks.skip=true)
- a -Prelease profile that activates plugins to upload to ossrh (signing, javadoc, source jar)
- a -Pjacoco enabling jacoco
- PluginManagement for various plugins, this means that they are enabled only if you repeat them in the <build><plugins> section of your pom : maven-templating-plugin (filter-src), maven-failsafe-plugin (integration-test, verify), maven-plugin-plugin (process-class, utilisé par itools-packager uniquement..), maven-shade-plugin

Additionally, a powsybl-parent-ws using spring and jib is available. It provides
- spring-boot-maven-plugin and jib-maven-plugin and git-commit-id-plugin versions
- pluginmanagement for these plugins that you must include in your spring-boot module
- automatic spring fat-jar generation (can be disabled with -Dpowsybl.spring-boot.skip=true)
- profiles for generating docker images that can be enabled on the command line, bound to their respective maven phase:
  - -Dpowsybl.docker.package : build a .tar file in target containing the image
  - -Dpowsybl.docker.install : install the image to the docker daemon (requires a docker daemon). This has the advantage of not storing the base image everytime and saves a lot of disk space (hundreds of MBs depending on the image)
  - -Dpowsybl.docker.deploy : deploy the docker image to a docker registry
  - default configuration mimicking spring-boot-starter-parent for default plugins (maven-compiler-plugin, maven-resource-plugin)
