#!/usr/bin/env bash
set -euo pipefail

REPO="${GITHUB_REPOSITORY:-arthurguedesribeiro02-dev/WinJalBionic_Cmod}"
TAG="${1:-v0.1.0}"
TITLE="${2:-WinJalBionic Cmod ${TAG}}"
APK_DIR="${APK_DIR:-app/build/outputs/apk}"

command -v gh >/dev/null || { echo 'gh CLI não encontrado' >&2; exit 1; }
[ -d "$APK_DIR" ] || { echo "Diretório de APK não encontrado: $APK_DIR" >&2; exit 1; }
mapfile -t APKS < <(find "$APK_DIR" -type f -name '*.apk' -print)
[ "${#APKS[@]}" -gt 0 ] || { echo 'Nenhum APK encontrado; compile primeiro' >&2; exit 1; }

mkdir -p release-assets
cp "${APKS[@]}" release-assets/
sha256sum release-assets/*.apk > release-assets/SHA256SUMS.txt

if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "A release $TAG já existe. Use outro tag ou apague-a explicitamente." >&2
  exit 2
fi

echo "Arquivos que serão publicados em https://github.com/$REPO/releases/tag/$TAG:"
find release-assets -maxdepth 1 -type f -printf ' - %f\n'

gh release create "$TAG" release-assets/* \
  --repo "$REPO" \
  --title "$TITLE" \
  --generate-notes \
  --prerelease
