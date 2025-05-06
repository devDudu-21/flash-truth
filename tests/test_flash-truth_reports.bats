#!/usr/bin/env bats

setup() {
  SCRIPT="./flash-truth.sh"
  if [[ ! -x "$SCRIPT" ]]; then
    skip "flash-truth.sh not found or not executable"
  fi
  rm -f flashtruth_relatorio_*.txt flashtruth_report_*.txt
}

@test "Verifica se relatório é gerado após verificação mock direta" {
  run env LANGUAGE=pt ./flash-truth.sh --mock-check <<< "1"
  report=$(find . -maxdepth 1 -type f \( -name "flashtruth_relatorio_*.txt" -o -name "flashtruth_report_*.txt" \) | tail -n 1)
  [ -n "$report" ]
  [ -f "$report" ]
}

@test "Verifica se confiabilidade aparece após verificação" {
  run env LANGUAGE=pt ./flash-truth.sh --mock-check <<< "1"
  echo "$output" | grep -q "Confiabilidade"
}
