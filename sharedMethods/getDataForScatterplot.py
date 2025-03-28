#########################################################################################################
#
# Run this script like this from project root: python sharedMethods/getDataForScatterplot.py "Stage 4"
#
#########################################################################################################

import sys
import os
import re
import csv

stagesAndLastCommit = []

def getStageBumpsAndLastCommit(title, completePath):
    data = []

    with open(completePath, "r") as file:

        data.append(title)

        fileContent = file.read()
        match = re.search(r"Stage 1:\s+([^\s<]+)", fileContent)
        print("Stage 1:", match.group(1).strip())
        data.append(match.group(1).strip())

        match = re.search(r"Stage 2:\s+([^\s<]+)", fileContent)
        print("Stage 2:", match.group(1).strip())
        data.append(match.group(1).strip())
        
        match = re.search(r"Stage 2.7:\s+([^\s<]+)", fileContent)
        print("Stage 2.7:", match.group(1).strip())
        data.append(match.group(1).strip())
        
        match = re.search(r"Stage 3:\s+([^\s<]+)", fileContent)
        print("Stage 3:", match.group(1).strip())
        data.append(match.group(1).strip())

        match = re.search(r"Stage 4:\s+([^\s<]+)", fileContent)
        print("Stage 4:", match.group(1).strip())
        data.append(match.group(1).strip())

        match = re.search(r"Last Commit:\s+([^\s<]+)", fileContent)
        print("Last Commit:", match.group(1).strip())
        data.append(match.group(1).strip())

    return data




def mainExtractMethod(stage):
    print("Extracting:", stage)

    path = f"Obsidian_TC39_Proposals/Proposals/{stage}/"

    print("Path:", path)

    stagesAndLastCommit.append(["Title", "Stage 1", "Stage 2", "Stage 2.7", "Stage 3", "Stage 4", "Last Commit"])
    
    for each in os.listdir(path):
        
        try:
            completePath = os.path.join(path, each)
        
            title = each.split(".")[0]

            print(title)

            stagesAndLastCommit.append(getStageBumpsAndLastCommit(title, completePath))

        except:
            print("Error with:", completePath)

if __name__ == "__main__":
    stage = sys.argv[1]
    mainExtractMethod(stage)

    with open(f"Data Analysis/Scatterplot/{stage}.csv", "w", newline='') as file:
        writer = csv.writer(file)
        writer.writerows(stagesAndLastCommit)
    
