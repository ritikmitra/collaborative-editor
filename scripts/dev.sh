#!/usr/bin/env bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting backend..."
(
    cd "$ROOT_DIR/backend"
    source .venv/bin/activate
    python -m uvicorn app.main:app --reload
) &

BACKEND_PID=$!

echo "Starting frontend..."
(
    cd "$ROOT_DIR/frontend"
    npm run dev
) &

FRONTEND_PID=$!

cleanup() {
    echo ""
    echo "Stopping services..."

    kill "$BACKEND_PID" 2>/dev/null || true
    kill "$FRONTEND_PID" 2>/dev/null || true

    wait "$BACKEND_PID" 2>/dev/null || true
    wait "$FRONTEND_PID" 2>/dev/null || true
}

trap cleanup INT TERM EXIT

wait
