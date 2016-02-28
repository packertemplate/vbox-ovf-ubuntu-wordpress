# vbox-ovf-ubuntu-wordpress

This projects is a helper to fast creation of boxes using packer and store them in atlas.

This build will be local, and we will be using `virtualbox-ovf` builder.

This project will create vagrant boxes ready to run go16.

## Pre Requirements

- Have ATLAS_TOKEN set

## How to use this repo

- `git clone <this repo> <project name>`


- Edit Makefile

```Makefile
#atlas username or atlas organization to upload the boxes
username = alvaro
# ie sufix = -project
sufix = -wordpress
# path for source files
# source = source
```

In order to use the same source files in more than one project, you can set a variable
ie `export source=<path>` or you can uncomment and the same in the Makefile
`source=<path>`

- Update /scripts/provision.sh

## First run

On first run, it will download ubuntu base images from canonical, and will use those images as base.

## Build

You can build all the boxes listed with `make list` or one in particular as `make name.box`

```
make list
precise.box trusty.box vivid.box wily.box
make precise.box
make
```

