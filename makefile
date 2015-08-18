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

JOB_SLOTS=4
DIR_BIN=./bin/
DIR_BOOT=./src/boot/
DIR_BUILD=./build/

all: build

build: clean _init _boot

clean:
	rm -rf $(DIR_BIN)
	rm -rf $(DIR_BUILD)

_init:
	mkdir $(DIR_BIN)
	mkdir $(DIR_BUILD)

_boot: 
	@echo ''
	@echo '============================================'
	@echo 'BUILDING BOOTLOADERS'
	@echo '============================================'
	cd $(DIR_BOOT) && make build -j $(JOB_SLOTS)
