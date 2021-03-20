# docker-build-repo
This project is used for building docker images using GitHub actions.

## Docker build Workflow specification

This project uses `Github Action` to automatically build docker images.

All the workflows is defined in `Makefile` file.

And please mark the old workflow as archived workflow in `Makefile` and remove it in main building workflow in `Makefile` under `.PHYNO: all`

**Directory hierarchy rules of arranging docker build scripts**

* All projects must be listed under `root` directory.

* Using `version spec` number to differentiate `different versions of docker images`
