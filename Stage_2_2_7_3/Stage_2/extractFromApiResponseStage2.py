from sharedMethods.processApiResponse import prepText, extractDetails

# Open and read the file content
with open("Stage_2_2_7_3/Stage_2/outputMD/delegatedApiResponse.md", "r") as file:
    fileContent = file.read()

text = prepText(fileContent)

extractResults = extractDetails(text, fileContent)

with open("Stage_2_2_7_3/Stage_2/outputMD/apiResults.md", "w") as results:
    for each in extractResults:
        if "error with this link:" not in each:
            results.write(str(each) + "\n")

