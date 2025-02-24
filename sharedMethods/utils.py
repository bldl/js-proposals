import os
import requests
from dotenv import load_dotenv
import re

#--------------------------------Helper methods-----------------------------------#

def getCommitMessages(apiLink):

    allCommits = []

    print(apiLink)
    load_dotenv()
    apiLink = f"https://api.github.com/repos/tc39/{apiLink}/commits"
    apiRequest = requests.get(apiLink, auth=(os.getenv("USERNAME"), os.getenv("API_KEY")))
    apiResponse = apiRequest.json()

    while 'next' in apiRequest.links:
        apiRequest = requests.get(apiRequest.links['next']['url'], auth=(os.getenv("USERNAME"), os.getenv("API_KEY")))
        apiResponse.extend(apiRequest.json())

    with open(f"sharedMethods/workingCommit.md", "w") as commitHistory:
        commitHistory.write(f"{apiResponse}") 
    
    for each in apiResponse:
        message = each["commit"]["message"]
        author = each["commit"]["author"]["name"]
        date = each["commit"]["author"]["date"].split("T")[0]

        if "Stage" in message:
            allCommits.append((message, author, date))
    
    return allCommits

def extractStageUpgrades(commitHistory):
        
    for each in commitHistory:
        message = each[0]
        author = each[1]
        date = each[2]

        print(message.split())
    

#---------------------------------------------------------------------------------#

path = "Obsidian_TC39_Proposals/Proposals/Stage 4 Proposals/"

for file in os.listdir(path):
    
    filename = os.path.join(path, file)
    
    with open(filename, "r") as file:

        fileContent = file.read()

        #githubLink = re.search(r"GitHub Link:\s(\S+)", fileContent).group(1).split("/")[-1]

# Testing purposes
githubLink = "proposal-weakrefs"

# master does not work if in catch clause, master needs to be processed before mai

stageRelatedCommits = getCommitMessages(githubLink)

extractStageUpgrades(stageRelatedCommits)



    
        