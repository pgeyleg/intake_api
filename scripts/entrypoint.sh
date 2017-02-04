#!/usr/bin/env bash
set -e

export SECRET_KEY_BASE=$(openssl rand -base64 32)

# Hand off to application process
exec "$@"