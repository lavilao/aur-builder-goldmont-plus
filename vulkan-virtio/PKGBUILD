# Maintainer: Laurent Carlier <lordheavym@gmail.com>
# Maintainer: Felix Yan <felixonmars@archlinux.org>
# Maintainer: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
# Contributor: Jan de Groot <jgc@archlinux.org>
# Contributor: Andreas Radke <andyrtr@archlinux.org>

pkgbase=mesa
pkgname=(
  vulkan-virtio
)
pkgver=25.0.3
pkgrel=1
epoch=1
pkgdesc="Open-source OpenGL drivers"
url="https://www.mesa3d.org/"
arch=(x86_64)
license=("MIT AND BSD-3-Clause AND SGI-B-2.0")
makedepends=(
  clang
  expat
  gcc-libs
  glibc
  libdrm
  libelf
  libglvnd
  libx11
  libxcb
  libxext
  libxshmfence
  libxxf86vm
  llvm
  llvm-libs
  systemd-libs
  vulkan-icd-loader
  wayland
  xcb-util-keysyms
  zlib
  zstd

  # shared between mesa and lib32-mesa
  cmake
  meson
  python-mako
  python-packaging
  python-ply
  python-yaml
  wayland-protocols
  xorgproto
)
options=(
  !lto
)
source=(
  "https://mesa.freedesktop.org/archive/mesa-$pkgver.tar.xz"{,.sig}
)
validpgpkeys=(
  946D09B5E4C9845E63075FF1D961C596A7203456 # Andres Gomez <tanty@igalia.com>
  71C4B75620BC75708B4BDB254C95FAAB3EB073EC # Dylan Baker <dylan@pnwbakers.com>
  8703B6700E7EE06D7A39B8D6EDAE37B02CEB490D # Emil Velikov <emil.l.velikov@gmail.com>
  57551DE15B968F6341C248F68D8E31AFC32428A6 # Eric Engestrom <eric@engestrom.ch>
  A5CC9FEC93F2F837CB044912336909B6B25FADFA # Juan A. Suarez Romero <jasuarez@igalia.com>
  E3E8F480C52ADD73B278EE78E1ECBE07D7D70895 # Juan Antonio Suárez Romero (Igalia, S.L.) <jasuarez@igalia.com>
)

b2sums=('8b32119756c422b780b466ed4ba60660d2c91f8f460b617f7417e5f3ae2a5cd44a95abedbcdfb8e2f38d99fb2e4f1610586e846fe13b9db979f5156dcc268614'
        'SKIP')

prepare() {
  cd mesa-$pkgver

  # Include package release in version string so Chromium invalidates
  # its GPU cache; otherwise it can cause pages to render incorrectly.
  echo "$pkgver-arch$epoch.$pkgrel" >VERSION
}

build() {
  local meson_options=(
    -D android-libbacktrace=disabled
    -D b_ndebug=true
    -D gallium-drivers=virgl
    -D vulkan-drivers=virtio
    -D platforms=x11,wayland
    -D gallium-nine=false
    -D gallium-opencl=disabled
    -D gles1=disabled
    -D gles2=disabled
    -D glx=disabled
    -D egl=disabled
    -D gbm=disabled
    -D osmesa=false
    -D tools=
    -D vulkan-layers=
  )

  # Build only minimal debug info to reduce size
  CFLAGS+=" -g1"
  CXXFLAGS+=" -g1"

  arch-meson mesa-$pkgver build "${meson_options[@]}"
  meson compile -C build
}

_pick() {
  local p="$1" f d; shift
  for f; do
    d="$srcdir/$p/${f#$pkgdir/}"
    mkdir -p "$(dirname "$d")"
    mv -v "$f" "$d"
    rmdir -p --ignore-fail-on-non-empty "$(dirname "$f")"
  done
}

package_vulkan-virtio() {
  pkgdesc="Open-source Vulkan driver for Virtio-GPU (Venus)"
  depends=(
    expat
    gcc-libs
    glibc
    libdrm
    libx11
    libxcb
    libxshmfence
    systemd-libs
    vulkan-icd-loader
    wayland
    xcb-util-keysyms
    zlib
    zstd
  )
  optdepends=()
  provides=(vulkan-driver)

  DESTDIR="$pkgdir" meson install -C build

  # Remove unnecessary files
  rm -rf "$pkgdir"/usr/{bin,include,lib/libvulkan_*.so,share}
  rm -f "$pkgdir"/usr/lib/libgallium*.so*
  rm -f "$pkgdir"/usr/lib/libglapi.so*
  rm -f "$pkgdir"/usr/lib/libxatracker.so*

  # Keep only virtio files
  find "$pkgdir"/usr/lib -type f -not -name '*virtio*' -delete
  find "$pkgdir"/usr/share/vulkan/icd.d -type f -not -name '*virtio*' -delete

  install -Dm644 mesa-$pkgver/docs/license.rst -t "$pkgdir/usr/share/licenses/$pkgname"
}
