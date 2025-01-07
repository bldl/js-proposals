def extractTitle(fileContent):
    first = fileContent.index("|")
    last = fileContent.rindex("|")

    proposalDetails = fileContent[first:last]

    text = proposalDetails.splitlines()

    proposalTitles = []

    for n in text:    
        words = n.strip().split("|")
        compoundTitle = words[1]
        splitTitle = compoundTitle.split("][")
        title = splitTitle[0]

        stringTitle = title[2:]

        if stringTitle[0] == "`":
            stringTitle = stringTitle[1:len(stringTitle)-1]
            proposalTitles.append(stringTitle)
        else: 
            proposalTitles.append(stringTitle)

    #first line contains table title and line. remove this  

    return proposalTitles[2:]
