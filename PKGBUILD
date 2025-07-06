# Maintainer: robertfoster

CFLAGS+=" -march=goldmont-plus -mtune=goldmont-plus"
CXXFLAGS+=" -march=goldmont-plus -mtune=goldmont-plus"

_name=llama.cpp
pkgbase="${_name}-git"
pkgname=(
	"${pkgbase}"
)
pkgver=b4879
pkgrel=1
pkgdesc="Port of Facebook's LLaMA model in C/C++"
arch=('armv7h' 'aarch64' 'x86_64')
url="https://github.com/ggerganov/llama.cpp"
license=("MIT")
depends=()
makedepends=(
	'cmake'
	'git'
	'openblas'
	'openblas64'
)
conflicts=("${_name}")
provides=("${_name}")
source=("${_name}::git+${url}"
	"kompute::git+https://github.com/nomic-ai/kompute.git"
	"${_name}.conf"
	"${_name}.service")

pkgver() {
	cd "${srcdir}/${_name}"
	printf "%s" "$(git describe --tags | sed 's/-/./g')"
}

prepare() {
	cd "${srcdir}/${_name}"
	git submodule init
	git config submodule.kompute.url "${srcdir}/kompute"
	git -c protocol.file.allow=always submodule update

	for _pkg in "${pkgname[@]}"; do
		if [ ! -d "${srcdir}/${_pkg%-git}" ]; then
			cp -r "${srcdir}/${_name}" "${srcdir}/${_pkg%-git}"
		fi
	done
}

build() {
	local _cmake_args=(
		-B build
		-S .
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_BUILD_TYPE=Release
		-DGGML_MPI=OFF
		-DGGML_BLAS=ON
		-DGGML_BLAS_VENDOR=OpenBLAS
		-DBLAS_LIBRARIES="/usr/lib/libopenblas.so"
		-DLAPACK_LIBRARIES="/usr/lib/libopenblas.so"
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
	)

	cd "${srcdir}/${_name}"
	cmake "${_cmake_args[@]}"
	cmake --build build
}

package_llama.cpp-git() {
	pkgdesc="$pkgdesc (with OPENBlas CPU optimizations)"
	depends+=('openblas'
		'openblas64')
	provides=("${_name}")

	cd "${_name}"
	DESTDIR="${pkgdir}" cmake --install build
	_package
}

_package() {
	rm -rf "${pkgdir}/usr/bin/"*
	cd build/bin/
	for i in *; do
		install -Dm755 "${i}" \
			"${pkgdir}/usr/bin/${i}"
	done

	# systemd
	install -D -m644 "${srcdir}/${_name}.conf" \
		"${pkgdir}/etc/conf.d/${_name}"
	install -D -m644 "${srcdir}/${_name}.service" \
		-t "${pkgdir}/usr/lib/systemd/system"

	# it conflicts with whisper.cpp
	rm -f "${pkgdir}/usr/include/ggml.h"
}

sha256sums=('SKIP'
	'SKIP'
	'SKIP'
	'SKIP')