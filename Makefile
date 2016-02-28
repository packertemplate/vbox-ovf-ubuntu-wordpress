#Makefile
#atlas username or organization in atlas to upload the boxes
username = alvaro
# ie sufix = -project
sufix = -wordpress
# path for source files
# source = source

# start
.Phony: all

ifndef ATLAS_TOKEN
    $(error ATLAS_TOKEN is undefined)
endif

source ?= source
OS = precise trusty vivid wily
OSDIR := $(foreach os, $(OS), $(os)/)
OVF := $(foreach os, $(OS), $(source)/$(os)/box.ovf)
BOXES := $(foreach os, $(OS), $(os).box)

all: $(OVF) $(BOXES)

list:
	@echo $(BOXES)

clean:
	-@rm *.box

cleanall:
	-rm -fr $(OSDIR)

%.box: $(OVF)
	-@rm -fr output-vbox-ovf/
	packer build -var "os=$(@:.box=)" -var "source=$(source)" -var "username=$(username)" -var "vm_name=$(@:.box=$(sufix))" template.json

#12.04
$(source)/precise/box.ovf:
	-@mkdir -p $(source)/precise/
	-@curl -sSL -k https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box | tar xv -C $(source)/precise/

#14.04
$(source)/trusty/box.ovf:
	-@mkdir -p $(source)/trusty/
	-@curl -sSL -k https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box | tar xv -C $(source)/trusty/

#15.04
$(source)/vivid/box.ovf:
	-@mkdir -p $(source)/vivid/
	-@curl -sSL -k https://cloud-images.ubuntu.com/vagrant/vivid/current/vivid-server-cloudimg-amd64-vagrant-disk1.box | tar xv -C $(source)/vivid/

#15.10
$(source)/wily/box.ovf:
	-@mkdir -p $(source)/wily/
	-@curl -sSL -k https://cloud-images.ubuntu.com/vagrant/wily/current/wily-server-cloudimg-amd64-vagrant-disk1.box | tar xv -C $(source)/wily/
