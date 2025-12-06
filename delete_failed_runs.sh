#!/bin/bash

# Script para eliminar todas las ejecuciones fallidas de GitHub Actions
# Uso: ./delete_failed_runs.sh

echo "🚀 Eliminando todas las ejecuciones fallidas de GitHub Actions..."

# Obtener todos los IDs de ejecuciones fallidas y eliminarlas
FAILED_RUNS=$(gh run list --limit 50 --json conclusion,databaseId | jq -r '.[] | select(.conclusion == "failure") | .databaseId')

if [ -z "$FAILED_RUNS" ]; then
    echo "✅ No se encontraron ejecuciones fallidas."
    exit 0
fi

echo "📊 Ejecuciones fallidas encontradas:"
echo "$FAILED_RUNS" | wc -l

while IFS= read -r run_id; do
    if [ -n "$run_id" ]; then
        echo "🗑️  Eliminando ejecución: $run_id"
        gh run delete "$run_id"
    fi
done <<< "$FAILED_RUNS"

echo "✅ Proceso completado. Todas las ejecuciones fallidas han sido eliminadas."