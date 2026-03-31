# patch replaces real functions with fakes
# Mock creates fake objects that mimic real ones like HTTP response
from unittest.mock import patch, Mock
import pytest
import requests
from python.health_check import check_endpoints


# Mock: URL that returns 200 should be marked healthy
@patch("python.health_check.requests.get")
def test_healthy_endpoint(mock_get):
    # Fake a 200 response
    mock_get.return_value = Mock(status_code=200)
    results = check_endpoints(["https://fake.com"], retries=1, delay=0)
    assert results[0]["healthy"] is True
    assert results[0]["status"] == 200


# Mock: URL that returns 500 should be marked unhealthy
@patch("python.health_check.requests.get")
def test_unhealthy_endpoint(mock_get):
    # Fake a 500 response
    mock_get.return_value = Mock(status_code=500)
    results = check_endpoints(["https://fake.com"], retries=1, delay=0)
    assert results[0]["healthy"] is False
    assert results[0]["status"] == 500


# Mock: URL that crashes should retry and then be marked unhealthy
@patch("python.health_check.requests.get")
def test_connection_error_retries(mock_get):
    # Fake connection error every time requests.get is called
    mock_get.side_effect = requests.RequestException("Connection failed")
    results = check_endpoints(["https://fake.com"], retries=3, delay=0)
    assert results[0]["healthy"] is False
    assert results[0]["status"] is None
    # Verify it tried 3 times 
    assert mock_get.call_count == 3


# Test: real endpoint should respond and be marked healthy
@pytest.mark.live
def test_real_endpoint():
    results = check_endpoints(["https://google.com"], retries=2, delay=1)
    assert results[0]["healthy"] is True
    assert results[0]["status"] == 200
