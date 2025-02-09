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

## Uncomment this to send proposals to obsidian as a single file
#
#with open("Obsidian_TC39_Proposals/Proposals/Stage_2.md", "w") as results:
#    results.write("#Stage2Tag\n")
#    for each in extractResults:
#        if "error with this link:" not in each:
#            results.write(str(each) + "\n")