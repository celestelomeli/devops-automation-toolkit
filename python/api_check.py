import requests 
import argparse

# Argument parsing to get repo name from user input
parser = argparse.ArgumentParser(description="Fetch GitHub repository details")
parser.add_argument("repo", help="GitHub repository in the format 'owner/repo'")
args = parser.parse_args()

try:
    response = requests.get(f"https://api.github.com/repos/{args.repo}")
    # error handling for HTTP errors
    if response.status_code != 200:
        print(f"Error: could not fetch repo (status {response.status_code})")
        exit(1)
    data = response.json()
    print(f"Name: {data['name']}")
    print(f"Description: {data['description']}")
    print(f"Stars: {data['stargazers_count']}")
    print(f"Language: {data['language']}")

except requests.exceptions.RequestException:
    print("Error: network request failed or invalid repository format.")
    exit(1)
