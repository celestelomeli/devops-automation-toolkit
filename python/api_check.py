import requests 
import argparse
import json

# Check GitHub repo details using the API
def check_repo(repo):
    try:
        response = requests.get(f"https://api.github.com/repos/{repo}")
        # error handling for HTTP errors
        if response.status_code != 200:
            return {"repo": repo, "status": response.status_code, "success": False}
        data = response.json()
        return {
            "repo": repo,
            "status": 200,
            "success": True,
            "name": data.get("name"),
            "description": data.get("description"),
            "stars": data.get("stargazers_count"),
            "language": data.get("language")
        }
    except requests.RequestException:
        return {"repo": repo, "status": None, "success": False}

# Parse arguments, run check_repo, and print results
def main():
    # Argument parsing to get repo name from user input
    parser = argparse.ArgumentParser(description="Fetch GitHub repository details")
    parser.add_argument("repo", help="GitHub repository in the format 'owner/repo'")
    parser.add_argument("--json", action="store_true", dest="as_json", help="Output results in JSON format")
    args = parser.parse_args()

    result = check_repo(args.repo)
    if args.as_json:
        print(json.dumps(result, indent=2))
    elif result["success"]:
        print(f"Name: {result['name']}")
        print(f"Description: {result['description']}")
        print(f"Stars: {result['stars']}")
        print(f"Language: {result['language']}")
    else:
        print(f"Error: could not fetch repo (status {result['status']})")
        exit(1)

if __name__ == "__main__":
    main()