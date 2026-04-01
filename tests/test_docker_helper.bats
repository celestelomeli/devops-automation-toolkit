# Test: help flag prints instructions and exits successfully
@test "help flag prints usage" {
    run bash bash/docker_helper.sh --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

# Test: unrecognized command should fail with exit 1
@test "unknown command fails" {
    run bash bash/docker_helper.sh banana
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown command"* ]]
}

# Test: script fails when docker is not installed
@test "fails when docker is not installed" {
    # Use minimal PATH so bash works but docker is hidden
    PATH="/usr/bin:/bin" run bash bash/docker_helper.sh build
    [ "$status" -eq 1 ]
    [[ "$output" == *"Docker not found"* ]]
}

# Test: build fails when no Dockerfile exists in the directory
@test "build fails with no Dockerfile" {
    # Create a temp directory with no Dockerfile
    tmp=$(mktemp -d)
    run bash bash/docker_helper.sh build "$tmp"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No Dockerfile found"* ]]
    rm -rf "$tmp"
}

# Test: passing a directory that doesn't exist should fail
@test "fails when directory does not exist" {
    run bash bash/docker_helper.sh build /fake/path
    [ "$status" -eq 1 ]
    [[ "$output" == *"does not exist"* ]]
}
