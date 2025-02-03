
# Import extractTitle from processApiResponse
from sharedMethods.processApiResponse import prepText, extractDetails

# Open and read the file content
with open("Stage_4/outputMD/apiResponse.md", "r") as file:
    fileContent = file.read()

rawText = prepText(fileContent)

extractResults = extractDetails(rawText, fileContent)

with open("Stage_4/outputMD/apiResults.md", "w") as results:
    for each in extractResults:
        if "error with this link:" not in each:
            results.write(str(each) + "\n")

with open("Obsidian_TC39_Proposals/Proposals/Stage_4.md", "w") as results:
    results.write("#Stage4Tag\n")
    for each in extractResults:
        if "error with this link:" not in each:
            results.write(str(each) + "\n")

