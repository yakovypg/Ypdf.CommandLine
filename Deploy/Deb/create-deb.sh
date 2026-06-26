#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------- Parameter constants (edit these) --------
CSPROJ_PATH="$SCRIPT_DIR/../../Application/Ypdf.CommandLine/Ypdf.CommandLine.csproj"

APP_NAME="Ypdf.CommandLine"         # Application name used as /opt path
APP_VERSION="2.0.0"                 # Application version
EXEC_NAME="ypdf"                    # Executable name inside publish output
EXEC_LAUNCHER="ypdf"                # Launcher in /usr/bin
PACKAGE_NAME="ypdf"                 # Deb package name
PACKAGE_VERSION="0:$APP_VERSION-1"  # Deb package version (epoch:upstream_version-debian_revision)
PACKAGE_SECTION="utils"             # Deb package section
PACKAGE_PRIORITY="optional"         # Deb package priority
PACKAGE_ARCH="amd64"                # Debian architecture label
PACKAGE_MAINTAINER="yakovypg"       # Deb package maintainer
PACKAGE_DEPENDS=""                  # Deb package dependencies (e.g. dotnet-runtime-10.0)
PACKAGE_DESCRIPTION="ypdf"          # Deb package description
PUBLISH_CONFIG="Release"            # Configuration
PUBLISH_FRAMEWORK="net10.0"         # Target framework
PUBLISH_RUNTIME_ID="linux-x64"      # Runtime identifier
PUBLISH_SELF_CONTAINED="true"       # Publish as self-contained application

# -------- Internal directories --------
OUT_DIR="$SCRIPT_DIR"           # Output directory for the resulting .deb
PUBLISH_DIR="$(mktemp -d)"      # Publish directory
PKGROOT="$(mktemp -d)"          # Package root directory

if [ ! -d "$OUT_DIR" ]; then
    mkdir -p "$OUT_DIR"
fi

# -------- Remove temp directories --------
cleanup() {
  rm -rf "$PUBLISH_DIR" "$PKGROOT"
}

trap cleanup EXIT

# -------- Publish application --------
if [ ! -f "$CSPROJ_PATH" ]; then
  echo "error: .csproj not found: $CSPROJ_PATH" >&2
  exit 1
fi

dotnet publish \
    "$CSPROJ_PATH" \
    --configuration "$PUBLISH_CONFIG" \
    --framework "$PUBLISH_FRAMEWORK" \
    --runtime "$PUBLISH_RUNTIME_ID" \
    --self-contained "$PUBLISH_SELF_CONTAINED" \
    --output "$PUBLISH_DIR"

# -------- Staging deb structure --------
mkdir -p "$PKGROOT/DEBIAN"
mkdir -p "$PKGROOT/opt/$APP_NAME"
mkdir -p "$PKGROOT/usr/bin"

# Copy all published files into package
cp -a "$PUBLISH_DIR/." "$PKGROOT/opt/$APP_NAME/"

# -------- Create launcher in /usr/bin so users can run application immediately --------
cat > "$PKGROOT/usr/bin/$EXEC_LAUNCHER" <<EOF
#!/bin/sh
exec /opt/$APP_NAME/$EXEC_NAME "\$@"
EOF

chmod 0755 "$PKGROOT/usr/bin/$EXEC_LAUNCHER"

# -------- Ensure executable exists --------
if [ ! -f "$PKGROOT/opt/$APP_NAME/$EXEC_NAME" ]; then
  echo "error: executable '$EXEC_NAME' not found at '$PKGROOT/opt/$APP_NAME/$EXEC_NAME'" >&2
  exit 1
fi

chmod 0755 "$PKGROOT/opt/$APP_NAME/$EXEC_NAME"

# -------- Configure DEBIAN/control --------
CONTROL_PATH="$PKGROOT/DEBIAN/control"

{
  echo "Package: $PACKAGE_NAME"
  echo "Version: $PACKAGE_VERSION"
  echo "Section: $PACKAGE_SECTION"
  echo "Priority: $PACKAGE_PRIORITY"
  echo "Architecture: $PACKAGE_ARCH"
  echo "Maintainer: $PACKAGE_MAINTAINER"
  if [ -n "$PACKAGE_DEPENDS" ]; then
    echo "Depends: $PACKAGE_DEPENDS"
  fi
  echo "Description: $PACKAGE_DESCRIPTION"
} > "$CONTROL_PATH"

# -------- Build deb --------
DEB_PATH="$OUT_DIR/${PACKAGE_NAME}_${APP_VERSION}_${PACKAGE_ARCH}.deb"
dpkg-deb --build "$PKGROOT" "$DEB_PATH"

# -------- Print summary --------
echo
echo "Built: $DEB_PATH"
echo
echo "Check deb package:"
echo "  dpkg-deb -c $DEB_PATH"
echo "  dpkg-deb -f $DEB_PATH"
echo "Install application:"
echo "  sudo apt install $DEB_PATH"
echo "Check application:"
echo "  $EXEC_LAUNCHER --version"
