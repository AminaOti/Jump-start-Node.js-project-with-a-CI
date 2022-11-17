# Jumpstart shell script

This shell script will 'jump start' the creation of a new node.js project with a fully integrated Travis the CI pipeline (shown below), to use this template please see 'Get started' section

## Travis CI Pipeline:

The following will be run on a commit & push:

- Snyk security scanning
- IBM detect secrets
- Prettier
- Eslint
- Commit Lint
- Unit tests

The following will be run on a pull-request:

- Sonar Cloud (tool to detect bugs & vulnerabilities )
- Snyk security scanning
- IBM detect secrets
- Unit tests

## Get started

1. Clone this repository
2. ```
   $ cd jumpstart-shell-scrip
   ```

3. ```
   $ bash jumpstart-shell-script.sh
   ```
