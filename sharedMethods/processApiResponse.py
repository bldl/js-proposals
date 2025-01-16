proposals = []
titles = []
authors = []
champions = []
dates = []
proposalLinks = {}
notesLinks = {}

def extractDetails(fileContent):

    global proposals

    first = fileContent.index("|")
    last = fileContent.rindex("|")

    proposalDetails = fileContent[first:last]

    text = proposalDetails.splitlines()

    for n in text:    
        words = n.strip().split("|")

        #Extract title and append to list 
        extractTitle(words)

        #Extract author and append to list
        extractAuthor(words)

        #Extract champion(s) and append to list 
        extractChampion(words)

        #Extract date and append to list 
        extractDate(words)

    #Extract proposal link and append to list 
    extractProposalLink(fileContent)

    #TODO add links to proposals via dictionary.get(title)

    for i in range(len(titles)):
        proposals.append((titles[i], authors[i], champions[i], dates[i]))

    #first line contains table title and line. remove this  
    
    return proposals[2:]

def extractTitle(words):

    #TODO find a way to separate title and linkname 

    compoundTitle = words[1]
    
    if compoundTitle[0] == "`":
            compoundTitle = compoundTitle[1:len(compoundTitle)-1]
            titles.append(compoundTitle)
    else: 
            titles.append(compoundTitle)

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
    global notesLinks
    global proposalLinks

    first = words.rindex("|")
    links = words[first:].splitlines()
    
    for link in links:

        try: 
            if "notes" in link:
                addLinkToDict(link, notesLinks)

            else:            
                addLinkToDict(link, proposalLinks)
        except Exception:
            print("error with this link:", link) 
            
        
#return tuples of linkName and url
#and add a dictionary key: value pair to the designated dictonary
def addLinkToDict(words, dictToUpdate):
    
    link = words.split()
    linkName = link[0].rstrip(":")
    url = link[1]

    dictToUpdate.update({linkName: url})

    




