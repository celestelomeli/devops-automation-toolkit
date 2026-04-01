# Test: help flag prints usage instructions and exits successfully
@test "help flag prints usage" {
    run bash bash/tf_wrapper.sh --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

# Test: passing a directory that doesn't exist should fail
@test "fails when directory does not exist" {
    run bash bash/tf_wrapper.sh fmt /fake/path
    [ "$status" -eq 1 ]
    [[ "$output" == *"does not exist"* ]]
}

# Test: passing a real directory with no .tf files should fail
@test "fails when no tf files in directory" {
    # Create a temp directory with no .tf files
    tmp=$(mktemp -d)
    run bash bash/tf_wrapper.sh fmt "$tmp"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No Terraform configuration files"* ]]
    rm -rf "$tmp"
}

# Test: unrecognized command falls through to default case and prints usage
@test "unknown command prints usage" {
    run bash bash/tf_wrapper.sh banana sample_data/terraform
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

# Test: fmt runs successfully against a valid terraform directory
@test "fmt works on valid terraform files" {
    run bash bash/tf_wrapper.sh fmt sample_data/terraform
    [ "$status" -eq 0 ]
    [[ "$output" == *"Running terraform fmt"* ]]
}

# Test: validate runs successfully against a valid terraform directory
@test "validate works on valid terraform files" {
    run bash bash/tf_wrapper.sh validate sample_data/terraform
    [ "$status" -eq 0 ]
    [[ "$output" == *"Running terraform validate"* ]]
}

# Test: script fails when terraform is not installed
@test "fails when terraform is not installed" {
    # Use minimal PATH so bash works but terraform is hidden
    PATH="/usr/bin:/bin" run bash bash/tf_wrapper.sh fmt
    [ "$status" -eq 1 ]
    [[ "$output" == *"Terraform not found"* ]]
}
