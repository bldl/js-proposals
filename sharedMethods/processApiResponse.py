import re

proposals = []
titles = []
linkTitles = []
authors = []
champions = []
dates = []

#TODO collect commit date
commitDate = []
links = []
noteLinks = []

proposalLinks = {}
notesLinks = {}

'''
This function extracts the details of the proposals from the file content

'''
def extractDetails(fileContent):

    global proposals

    first = fileContent.index("|")
    last = fileContent.rindex("|")

    proposalDetails = fileContent[first:last]

    textRaw = proposalDetails.splitlines()

    text = textRaw[2:]

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

    matchLinkWithProposal(linkTitles, proposalLinks)

    #TODO add links to proposals via dictionary.get(title)

    for i in range(len(titles)):
        proposals.append({"title": titles[i], "author(s)": authors[i], "champion(s)": champions[i], "date": dates[i], "link titles": linkTitles[i], "gitHub link": links[i]})

    #first line contains table title and line. remove this  
    
    return proposals

'''
This function extracts the title of the proposals from the file content
'''
def extractTitle(words):

    global titles
    global linkTitles
 
    extractedTitles = []

    compoundTitle = words[1].strip().split("[")

    for each in compoundTitle:
        # Preserve content with backticks, including brackets inside backticks
        if "`" in each:
            cleaned = each.strip()
        else:
            # Remove surrounding brackets and backticks outside backticks
            cleaned = re.sub(r"[`\[,\]]", "", each).strip()
            # Remove parentheses if not inside backticks
            cleaned = re.sub(r"[()]", "", cleaned).strip()

        # Remove any trailing `]` explicitly
        cleaned = re.sub(r"]$", "", cleaned).strip()

        cleaned = re.sub(r"`", "", cleaned).strip()

        extractedTitles.append(cleaned)
    
    titles.append(extractedTitles[1])
    linkTitles.append(extractedTitles[2])
        

#TODO fix this

def matchLinkWithProposal(linkTitles, proposalLinks):

    for each in linkTitles:
        addBrackets = "[" + each + "]"
        link = proposalLinks.get(addBrackets)
        links.append(link)

    
    
'''
This function extracts the author of the proposals from the file content 
'''

def extractAuthor(words):
    global authors
    author = words[2].strip()
    names = author.replace("<br />", ", ")
    authors.append(names)

'''
This function extracts the champion of the proposals from the file content
'''

def extractChampion(words):
    global champions 
    champion = words[3].strip()
    names = champion.replace("<br />", ", ")
    champions.append(names)

''' 
This function extracts the date of the proposals from the file content
'''

def extractDate(words):
    global dates 
    date = words[4].strip()
    extractedDate = ((date.split("][")[0])[1:])
    dates.append(extractedDate)

''' 
This function extracts the proposal link from the file content
'''

def extractProposalLink(words):
    global notesLinks
    global proposalLinks

    first = words.rindex("|")
    links = words[first:].splitlines()
    
    
    #Sort links into notes and proposals
    for link in links:

        try: 
            if "notes" in link:
                addLinkToDict(link, notesLinks)

            else:            
                addLinkToDict(link, proposalLinks)

        #log error message 
        except Exception:
            print("error with this link:", link) 
            
'''
This function adds a link to the dictionary
'''
def addLinkToDict(words, dictToUpdate):
    
    link = words.split()
    linkName = link[0].rstrip(":")
    url = link[1]

    dictToUpdate.update({linkName: url})

    




