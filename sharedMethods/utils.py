import os
import requests
from dotenv import load_dotenv
import re

from askGPT import stageUpgrade

#--------------------------------Helper methods-----------------------------------#

def getCommitMessages(apiLink):

    allCommits = []

    print("extracting commit history of", apiLink)
    load_dotenv()
    apiLink = f"https://api.github.com/repos/tc39/{apiLink}/commits"
    apiRequest = requests.get(apiLink, auth=(os.getenv("USERNAME"), os.getenv("API_KEY")))
    apiResponse = apiRequest.json()

    while 'next' in apiRequest.links:
        apiRequest = requests.get(apiRequest.links['next']['url'], auth=(os.getenv("USERNAME"), os.getenv("API_KEY")))
        apiResponse.extend(apiRequest.json())

    first = apiResponse.pop()
    message = first["commit"]["message"]
    author = first["commit"]["author"]["name"]
    date = first["commit"]["author"]["date"].split("T")[0]

    allCommits.append((message, author, date))

    
    for each in apiResponse:
        message = each["commit"]["message"]
        author = each["commit"]["author"]["name"]
        date = each["commit"]["author"]["date"].split("T")[0]

        if "stage" in message.lower():
            allCommits.append((message, author, date))

    with open(f"sharedMethods/workingCommit.md", "w") as commitHistory:
        commitHistory.write(f"{allCommits}") 
    
    return allCommits

def extractStageUpgrades(apiLink, commitHistory):
        
    for each in commitHistory:
        message = each[0]
        author = each[1]
        date = each[2]

    stringCommitHistory = str(commitHistory)

    gptResponse = stageUpgrade(apiLink, stringCommitHistory)

    return gptResponse
    

#---------------------------------------------------------------------------------#

path = "Obsidian_TC39_Proposals/Proposals/Stage 4 Proposals/"

for file in os.listdir(path):
    
    filename = os.path.join(path, file)
    
    with open(filename, "r") as file:

        fileContent = file.read()

        #githubLink = re.search(r"GitHub Link:\s(\S+)", fileContent).group(1).split("/")[-1]

# Testing purposes
githubLink = "proposal-array-from-async"

# master does not work if in catch clause, master needs to be processed before mai

stageRelatedCommits = getCommitMessages(githubLink)

gptResponse = extractStageUpgrades(githubLink, stageRelatedCommits)

print(gptResponse)


    
        