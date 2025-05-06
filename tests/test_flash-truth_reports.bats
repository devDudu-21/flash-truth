#!/usr/bin/env bats

setup() {
  SCRIPT="./flash-truth.sh"
  if [[ ! -x "$SCRIPT" ]]; then
    skip "flash-truth.sh not found or not executable"
  fi
  rm -f flashtruth_relatorio_*.txt
}

@test "Verifica se relatório é gerado após verificação mock direta" {
  run ./flash-truth.sh --mock-verificar <<< "1"
  report=$(ls flashtruth_relatorio_*.txt 2>/dev/null | tail -n 1)
  [ -n "$report" ]
  [ -f "$report" ]
}

@test "Verifica se confiabilidade aparece após verificação" {
  run ./flash-truth.sh --mock-verificar <<< "1"
  echo "$output" | grep -q "Confiabilidade"
}
