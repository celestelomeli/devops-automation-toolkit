from unittest.mock import patch, Mock
import pytest
import requests
from python.api_check import check_repo

@patch("python.api_check.requests.get")
def test_valid_repo(mock_get):
    mock_get.return_value= Mock(
        status_code=200,
        json=lambda: {
            "name": "linux",
            "description": "Linux kernel source tree",
            "stargazers_count": 180000,
            "language": "C"         
        }
    )
    result = check_repo("torvalds/linux")

    assert result["status"] == 200
    assert result["success"] is True
    assert result["name"] == "linux"
    assert result["language"] == "C"

@patch("python.api_check.requests.get")
def test_invalid_repo(mock_get):
    mock_get.return_value = Mock(status_code=404)
    result = check_repo("nonexistent/repo")

    assert result["status"] == 404
    assert result["success"] is False


@patch("python.api_check.requests.get")
def test_connection_error(mock_get):
    # Fake connection error when requests.get is called
    mock_get.side_effect = requests.RequestException("Connection failed")
    result = check_repo("torvalds/linux")

    assert result["status"] is None
    assert result["success"] is False

@patch("python.api_check.requests.get")
def test_missing_data(mock_get):
    # Fake a 200 response but with missing fields in the JSON
    mock_get.return_value = Mock(
        status_code=200,
        json=lambda: {
            "name": "linux",
            # description is missing
            "stargazers_count": 180000,
            # language is missing
        }
    )
    result = check_repo("torvalds/linux")

    assert result["status"] == 200
    assert result["success"] is True
    assert result["name"] == "linux"
    assert result["description"] is None
    assert result["language"] is None

@pytest.mark.live
def test_real_repo():
    result = check_repo("torvalds/linux")

    assert result["status"] == 200
    assert result["success"] is True
    assert result["name"] == "linux"
    assert result["language"] == "C"    