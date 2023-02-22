# Copyright 2023 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.PHONY: build-linux
build-linux:
	qmake
	make

.PHONY: package-linux
package-linux:
	tar -czvf minikube-gui-linux.tar.gz ./minikube-gui

.PHONY: build-macos
build-macos:
	qmake
	make

.PHONY: package-macos
package-macos:
	macdeployqt ./minikube-gui.app -qmldir=. -verbose=1 -dmg
	mv ./minikube-gui.dmg ./minikube-gui-macos.dmg

.PHONY: build-windows
build-windows:
	call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
	qmake
	nmake

.PHONY: package-windows
package-windows:
	& scripts\windows-publish.ps1 minikube-gui-windows minikube-gui.exe
	Compress-Archive -Path minikube-gui-windows minikube-gui-windows.zip

.PHONY: bump-version
bump-version:
	sed -i s/QVersionNumber::fromString\(.*\)/QVersionNumber::fromString\(\"$(VERSION)\"\)/ src/window.cpp
