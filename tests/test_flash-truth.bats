#!/usr/bin/env bats

@test "FlashTruth script exists and is executable" {
  run test -x ./flash-truth.sh
  [ "$status" -eq 0 ]
}

@test "Script shows ASCII art and exits with code 0 on immediate exit" {
  run bash -c "echo 0 | ./flash-truth.sh --mock"
  [[ "$output" == *"USB Flash Drive Checker"* ]]
  [ "$status" -eq 0 ]
}
