import argparse
import sys
import json
import logging
import time
import requests
import yaml

# Logging configuration
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


# Check list of urls and return results
def check_endpoints(urls, retries=3, delay=2):
    results = []
    for url in urls:
        # debug level for now to stay hidden
        logger.debug("Checking %s", url)
        # try each url for number of retries
        for attempt in range(retries):
            try:
                response = requests.get(url, timeout=10, headers={"User-Agent": "health-check/1.0"})
                code = response.status_code
                healthy = code < 400
                results.append({"url": url, "status": code, "healthy": healthy})
                if healthy:
                    logger.debug("OK: %s (status %s)", url, code)
                else:
                    logger.warning("FAIL: %s (status %s)", url, code)
                # response, no need to retry
                break
            except requests.RequestException:
                # retries left, wait and try again
                if attempt < retries - 1:
                    logger.warning("Retry %s/%s for %s", attempt + 1, retries - 1, url)
                    time.sleep(delay)
                # All retries used, mark as unhealthy
                else:
                    results.append({"url": url, "status": None, "healthy": False})
                    logger.error("FAIL: %s - all %s attempts failed", url, retries)
    return results


# Parse arguments, run health checks, and print results
def main():
    parser = argparse.ArgumentParser(description="Check health of HTTP endpoints")
    parser.add_argument("urls", nargs="*", help="URLs to check")
    parser.add_argument("--json", action="store_true", dest="as_json", help="Output results in JSON format")
    parser.add_argument("--config", help="Path to YAML config file")
    args = parser.parse_args()

    # Get urls from config file or command line
    if args.config:
        with open(args.config) as f:
            config = yaml.safe_load(f)
        urls = config["urls"]
    elif args.urls:
        urls = args.urls
    else:
        parser.error("Provide URLs or use --config")

    # health checks
    results = check_endpoints(urls)

    # Print results as json
    if args.as_json:
        print(json.dumps(results, indent=2))
    else:
        for r in results:
            status = "HEALTHY" if r["healthy"] else "UNHEALTHY"
            logger.info("[%s] %s (status: %s)", status, r['url'], r['status'])

    # Exit with 0 if all healthy, 1 if any failed 
    sys.exit(0 if all(r["healthy"] for r in results) else 1)


if __name__ == "__main__":
    main()
