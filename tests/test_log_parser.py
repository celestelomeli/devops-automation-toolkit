from python.log_parser import parse_log


# Test: file with both errors and warnings
def test_errors_and_warnings(tmp_path):
    # Create a small fake log file
    log_file = tmp_path / "test.log"
    log_file.write_text(
        "INFO App started\n"
        "ERROR Disk full\n"
        "WARNING Low memory\n"
        "ERROR Timeout\n"
    )
    result = parse_log(str(log_file))

    assert result["errors"] == 2
    assert result["warnings"] == 1
    assert "ERROR Disk full" in result["error_lines"][0]
    assert "ERROR Timeout" in result["error_lines"][1]
    assert "WARNING Low memory" in result["warning_lines"][0]


# Test: file with no errors or warnings
def test_clean_log(tmp_path):
    log_file = tmp_path / "test.log"
    log_file.write_text(
        "INFO App started\n"
        "INFO User logged in\n"
    )
    result = parse_log(str(log_file))

    assert result["errors"] == 0
    assert result["warnings"] == 0
    assert result["error_lines"] == []
    assert result["warning_lines"] == []


# Test: file that doesn't exist should raise FileNotFoundError
def test_file_not_found():
    try:
        parse_log("/fake/path/nonexistent.log")
        assert False, "Should have raised FileNotFoundError"
    except FileNotFoundError:
        pass


# Test: real log file from sample_data
def test_real_log_file():
    result = parse_log("sample_data/app.log")

    assert result["errors"] == 4
    assert result["warnings"] == 6
    assert len(result["error_lines"]) == 4
    assert len(result["warning_lines"]) == 6
