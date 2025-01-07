proposals = []
titles = []
authors = []
champions = []
dates = []
proposalLinks = []
notesLinks = []

def extractDetails(fileContent):

    first = fileContent.index("|")
    last = fileContent.rindex("|")

    proposalDetails = fileContent[first:last]

    text = proposalDetails.splitlines()

    for n in text:    
        words = n.strip().split("|")

        #Extract title
        stringTitle = extractTitle(words)
        filterTitles(stringTitle)

        #Extract author
        stringAuthor = extractAuthor(words)

        #Extract champion(s)
        stringChampion = extractChampion(words)

        #Extract date
        stringDate = extractDate(words)

    for i in range(len(titles)):
        proposals.append((titles[i], authors[i], champions[i], dates[i]))


    #Extract proposal link
    proposalLink = extractProposalLink(fileContent)

    #first line contains table title and line. remove this  
    
    return proposals[2:]

def extractTitle(words):

    #TODO find a way to separate title and linkname 

    compoundTitle = words[1]
    return compoundTitle

def filterTitles(stringTitle):
    global titles
    if stringTitle[0] == "`":
            stringTitle = stringTitle[1:len(stringTitle)-1]
            titles.append(stringTitle)
    else: 
            titles.append(stringTitle)

def extractAuthor(words):
    global authors
    author = words[2]
    names = author.replace("<br />", ", ")
    authors.append(names)

def extractChampion(words):
    global champions 
    champion = words[3]
    names = champion.replace("<br />", ", ")
    champions.append(names)

def extractDate(words):
    global dates 
    date = words[4]
    extractedDate = ((date.split("][")[0])[2:])
    dates.append(extractedDate)

def extractProposalLink(words):
    first = words.rindex("|")

    #TODO sort out the links so the links can be matched with the title

    links = words[first:].splitlines()
    #print(links)
    

