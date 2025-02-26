# gradle build

[![ci](https://github.com/Arda-cards/gradle-build-action/actions/workflows/ci.yaml/badge.svg)](https://github.com/Arda-cards/gradle-build-action/actions/workflows/ci.yaml)
[CHANGELOG.md](CHANGELOG.md)

This action build a gradle-based module.

## Contract with the build script

This action expects a gradle wrapper at the root of the project with the standard targets
`build` and `publish`.

## Arguments

See [action.yaml](action.yaml).

## Usage

```yaml
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          - distribution: corretto
          - java-version: '21'
      - uses: gradle/actions/setup-gradle@v4
      - id: build
        uses: arda-cards/gradle-build-action@v1
```

Permission Required

```yaml
    permissions:
      contents: read
      package: write
```
