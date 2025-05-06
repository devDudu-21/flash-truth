#!/usr/bin/env bats

@test "Test English language output" {
  run env LANGUAGE=en bash -c "/home/devdudu/workplace/flash-truth/flash-truth.sh --mock" <<< "0"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Mock mode enabled. Simulating drive..."* ]] || [[ "$output" == *"No mounted USB drive found."* ]]
  [[ "$output" == *"Select an option"* ]] || [[ "$output" == *"Exiting..."* ]]
}

@test "Test Portuguese language output" {
  run env LANGUAGE=pt bash -c "/home/devdudu/workplace/flash-truth/flash-truth.sh --mock" <<< "0"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Modo MOCK ativado. Simulando pendrive..."* ]] || [[ "$output" == *"Nenhum pendrive montado encontrado."* ]]
  [[ "$output" == *"Selecione uma opção"* ]] || [[ "$output" == *"Saindo..."* ]]
}
