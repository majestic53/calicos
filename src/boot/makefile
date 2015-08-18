# CalicOS
# Copyright (C) 2015 David Jolly
# ----------------------
#
# CalicOS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# CalicOS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CC=nasm
CC_FLAGS=-f bin -o 
DIR_BIN=./../../bin/
DIR_BUILD=./../../build/
DIR_SRC=./src/
BOOT=boot
BOOT0=boot0
BOOT1=boot1
PATH_IMG="/home/david/VirtualBox VMs/CalicOS/CalicOS.vhd"
PATH_IMG_BAK="/home/david/VirtualBox VMs/CalicOS/CalicOS.vhd_bak"

all: build

build:
	@echo ''
	@echo '--- BUILDING BOOTLOADERS -------------------'
	$(CC) $(CC_FLAGS) $(DIR_BIN)$(BOOT0) $(DIR_SRC)$(BOOT0).s
	$(CC) $(CC_FLAGS) $(DIR_BIN)$(BOOT1) $(DIR_SRC)$(BOOT1).s
	cat $(DIR_BIN)$(BOOT0) $(DIR_BIN)$(BOOT1) > $(DIR_BIN)$(BOOT)
	cat $(DIR_BIN)$(BOOT) $(PATH_IMG_BAK) > $(PATH_IMG)
	@echo '--- DONE -----------------------------------'
	@echo ''
