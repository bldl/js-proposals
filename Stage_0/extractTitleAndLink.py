#source /home/kwal/Documents/code/tc39_proposals_project/.venv/bin/activate

with open("Stage_0/linksStage0","r") as file:
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
        
with open("Stage_0/proposals_S0.md", "w") as proposals_S0:
    for title, link in proposals:
        proposals_S0.write(f"{title} {link}\n")

with open("Stage_0/proposals_combined_S0.md", "w") as proposal_combined_S0:
    for title, link in proposal_combined:
        proposal_combined_S0.write(f"{title} {link}\n")

with open("Stage_0/proposal_notes_S0.md", "w") as proposal_notes_S0:
    for title, link in proposal_notes:
        proposal_notes_S0.write(f"{title} {link}\n")

