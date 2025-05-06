#!/usr/bin/env bats

setup() {
  SCRIPT="./flash-truth.sh"
  if [[ ! -x "$SCRIPT" ]]; then
    skip "flash-truth.sh not found or not executable"
  fi
}

@test "Shows menu and exits cleanly with option 0" {
  run bash -c "echo 0 | ./flash-truth.sh --mock"
  [[ "$output" == *"Selecione uma opção"* ]] || [[ "$output" == *"Select an option"* ]]
  [ "$status" -eq 0 ]
}

@test "Handles invalid option then exits" {
  run bash -c "echo -e 'x\n0' | ./flash-truth.sh --mock"
  [[ "$output" == *"Opção inválida"* ]] || [[ "$output" == *"Invalid option"* ]]
}

@test "Handles non-numeric device choice gracefully" {
  run bash -c "echo -e '1\nabc\n' | ./flash-truth.sh --mock"
  [[ "$output" == *"Escolha inválida."* ]] || [[ "$output" == *"Invalid choice."* ]]
}
