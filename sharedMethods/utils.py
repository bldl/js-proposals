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
    
    for each in apiResponse:
        message = each["commit"]["message"]
        author = each["commit"]["author"]["name"]
        date = each["commit"]["author"]["date"].split("T")[0]

        if "Stage" in message:
            allCommits.append((message, author, date))
        
    for each in allCommits:
        message = each[0]
        author = each[1]
        date = each[2]

        print(message, author, date)
    

#---------------------------------------------------------------------------------#

path = "Obsidian_TC39_Proposals/Proposals/Stage 4 Proposals/"

for file in os.listdir(path):
    
    filename = os.path.join(path, file)
    
    with open(filename, "r") as file:

        fileContent = file.read()

        #githubLink = re.search(r"GitHub Link:\s(\S+)", fileContent).group(1).split("/")[-1]

# Testing purposes
githubLink = "proposal-logical-assignment"

# master does not work if in catch clause, master needs to be processed before mai

getCommitMessages(githubLink)



    
        