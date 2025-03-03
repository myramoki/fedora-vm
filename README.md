# fedora-vm

Simple scripts for creating generic fedora VMs

## Generic config that calls others

```bash
sudo sh -c "$(curl -sL https://raw.githubusercontent.com/myramoki/fedora-vm/main/setup.sh)"
```

## Basic env config

```bash
sudo sh -c "$(curl -sL https://raw.githubusercontent.com/myramoki/fedora-vm/main/setup-basic.sh)"
```

## Builder setup

Java, Gradle, SSH Keys to RO Github

```bash
sudo sh -c "$(curl -sL https://raw.githubusercontent.com/myramoki/fedora-vm/main/setup-builder.sh)"
```

## Basic Tomcat setup

Java, Gradle, and basic Tomcat

```bash
sudo sh -c "$(curl -sL https://raw.githubusercontent.com/myramoki/fedora-vm/main/setup-tomcat.sh)"
```

## Basic BN Tomcat Setup

Java, Gradle, Tomcat and SSL stuff

```bash
sudo sh -c "$(curl -sL https://raw.githubusercontent.com/myramoki/fedora-vm/main/setup-biznuvo.sh)"
```
