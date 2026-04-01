# Test: help flag prints instructions and exits successfully
@test "help flag prints usage" {
    run bash bash/check_env.sh --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

# Test: all required tools are found on this machine
@test "exits 0 when all tools are found" {
    # Skip in CI not all tools installed on the runner
    [ -n "${CI:-}" ] && skip "CI environment may not have all tools"
    run bash bash/check_env.sh
    [ "$status" -eq 0 ]
    [[ "$output" == *"All tools found."* ]]
}

# Test: script fails when tools are missing
@test "exits 1 when a tool is missing" {
    # Use minimal PATH so bash works but some tools are hidden
    PATH="/usr/bin:/bin" run bash bash/check_env.sh
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}
