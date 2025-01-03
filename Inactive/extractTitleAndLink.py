#source /home/kwal/Documents/code/tc39_proposals_project/.venv/bin/activate

with open("Inactive/linksInactive","r") as file:
    text = file.read()

proposals = []
proposal_notes = []
proposal_combined = []

def extractTitleAndLink(line):
    startTitle = line.find("[") + 1
    endTitle = line.find("]")
    title = line[startTitle:endTitle]
    
    startLink = line.find("https://")
    link = line[startLink:]
    
    return (title, link)

for line in text.split("\n"):
    proposal_combined.append(extractTitleAndLink(line))

    if "notes" not in line:
        proposals.append(extractTitleAndLink(line))
    
    else:
        proposal_notes.append(extractTitleAndLink(line))
        
with open("Inactive/proposals_IA.md", "w") as proposals_IA:
    for title, link in proposals:
        proposals_IA.write(f"{title} {link}\n")

with open("Inactive/proposals_combined_IA.md", "w") as proposal_combined_IA:
    for title, link in proposal_combined:
        proposal_combined_IA.write(f"{title} {link}\n")

with open("Inactive/proposal_notes_IA.md", "w") as proposal_notes_IA:
    for title, link in proposal_notes:
        proposal_notes_IA.write(f"{title} {link}\n")

