#source /home/kwal/Documents/code/tc39_proposals_project/.venv/bin/activate

with open("Finished/linksFinished","r") as file:
    text = file.read()

proposals = []
proposal_notes = []

def extractTitleAndLink(line):
    startTitle = line.find("[") + 1
    endTitle = line.find("]")
    title = line[startTitle:endTitle]
    
    startLink = line.find("https://")
    link = line[startLink:]
    
    return (title, link)

for line in text.split("\n"):

    if "notes" not in line:
        proposals.append(extractTitleAndLink(line))
    
    else:
        proposal_notes.append(extractTitleAndLink(line))
        
with open("Finished/outputMD/proposals_F.md", "w") as proposals_F:
    for title, link in proposals:
        proposals_F.write(f"{title} {link}\n")

with open("Finished/outputMD/proposal_notes_F.md", "w") as proposal_notes_F:
    for title, link in proposal_notes:
        proposal_notes_F.write(f"{title} {link}\n")

