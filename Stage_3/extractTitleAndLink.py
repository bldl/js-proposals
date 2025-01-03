#source /home/kwal/Documents/code/tc39_proposals_project/.venv/bin/activate

with open("Stage_3/linksStage3","r") as file:
    text = file.read()

proposals = []
proposal_notes = []
proposal_combined = []

def extractTitleAndLink(line):
    startTitle = line.find("[") + 1
    endTitle = line.find("]")
    title = line[startTitle:endTitle]
    
    startLink = line.find("https://")
    endLink = line.find("\n")
    link = line[startLink:endLink]
    
    return (title, link)

for line in text.split("\n"):
    proposal_combined.append(extractTitleAndLink(line))

    if "notes" not in line:
        proposals.append(extractTitleAndLink(line))
    
    else:
        proposal_notes.append(extractTitleAndLink(line))
        
with open("Stage_3/proposals_S3.md", "w") as proposals_S3:
    for title, link in proposals:
        proposals_S3.write(f"{title} {link}\n")

with open("Stage_3/proposals_combined_S3.md", "w") as proposal_combined_S3:
    for title, link in proposal_combined:
        proposal_combined_S3.write(f"{title} {link}\n")

with open("Stage_3/proposal_notes_S3.md", "w") as proposal_notes_S3:
    for title, link in proposal_notes:
        proposal_notes_S3.write(f"{title} {link}\n")

