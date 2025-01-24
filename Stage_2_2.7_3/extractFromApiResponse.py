import sys
import os

# Ensure the project root is in sys.path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, project_root)

# Import extractTitle from processApiResponse
from sharedMethods.processApiResponse import extractDetails

# Open and read the file content
with open("Finished/outputMD/apiResponse.md", "r") as file:
    fileContent = file.read()

# Use the extractTitle function

extractResults = extractDetails(fileContent)

with open("Finished/outputMD/apiResults.md", "w") as results:
    for each in extractResults:
        if "error with this link:" not in each:
            results.write(str(each) + "\n")

