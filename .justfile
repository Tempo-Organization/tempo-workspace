# Cross platform shebang:
shebang := if os() == 'windows' {
  'powershell.exe'
} else {
  '/usr/bin/env pwsh'
}

# Set shell for non-Windows OSs:
set shell := ["pwsh", "-c"]

# Set shell for Windows OSs:
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# If you have PowerShell Core installed and want to use it,
# use `pwsh.exe` instead of `powershell.exe`


alias list := default

default:
  just --list

setup:
  if (Test-Path ".venv") { Remove-Item ".venv" -Recurse -Force }
  if (Test-Path "tempo-cli") { Remove-Item "tempo-cli" -Recurse -Force }
  if (Test-Path "tempo-core") { Remove-Item "tempo-core" -Recurse -Force }
  if (Test-Path "tempo-binary-tool-manager") { Remove-Item "tempo-binary-tool-manager" -Recurse -Force }
  if (Test-Path "tempo-binary-tools") { Remove-Item "tempo-binary-tools" -Recurse -Force }
  if (Test-Path "tempo-settings") { Remove-Item "tempo-settings" -Recurse -Force }
  git clone --depth 1 -b dev --single-branch https://github.com/Tempo-Organization/tempo-cli.git
  git clone --depth 1 -b dev --single-branch https://github.com/Tempo-Organization/tempo-core.git
  git clone --depth 1 -b main --single-branch https://github.com/Tempo-Organization/tempo-binary-tool-manager.git
  git clone --depth 1 -b master --single-branch https://github.com/Tempo-Organization/tempo-binary-tools.git
  git clone --depth 1 -b main --single-branch https://github.com/Tempo-Organization/tempo-settings.git
  uv --directory ./tempo-binary-tools remove tempo-binary-tool-manager
  uv --directory ./tempo-core remove tempo-binary-tool-manager tempo-binary-tools tempo-settings
  uv --directory ./tempo-cli remove tempo-settings tempo-binary-tool-manager tempo-binary-tools tempo-core
  uv add --workspace ./tempo-binary-tool-manager ./tempo-settings ./tempo-binary-tools ./tempo-core ./tempo-cli
  uv sync

lint:
  uv run ruff check tempo-core/src tempo-core/tests tempo-cli/src tempo-settings/src tempo-binary-tools/src tempo-binary-tool-manager/src --fix
  uv run ty check tempo-core/src tempo-core/tests tempo-cli/src tempo-settings/src tempo-binary-tools/src tempo-binary-tool-manager/src --fix
