import ast
import requests
import base64
import os
from dotenv import load_dotenv

from sharedMethods.askGPT import classifyProposal

with open("Stage_0/outputMD/apiResults.md", "r") as file:
    fileContent = file.readlines()

data_list = [ast.literal_eval(line.strip()) for line in fileContent]

# Iterate over each dictionary and use pattern matching
for entry in data_list:
    match entry:
        case {
            "Title": title,
            "Author(s)": authors,
            "Champion(s)": champions,
            "Date": date,
            "Link Titles": link_titles,
            "GitHub Link": github_link,
            "GitHub Note Link": github_note_link
        }:

            link_title = link_titles.strip("[[]]")

            invalid_chars = '\\/*?:"<>|'
            for char in invalid_chars:
                link_titles = link_title.replace(char, "")

            try:
                apiProposalName = github_link.split("/")[-1]
                if "#" in apiProposalName:
                    apiProposalName = apiProposalName.split("#")[0]
            except:
                print("Error with link:", link_title)

            #----------api call for readme------------------------
            
            try:
                load_dotenv()
                githubReadme = f"https://api.github.com/repos/tc39/{apiProposalName}/contents/README.md"
                response = requests.get(githubReadme, auth=(os.getenv("USERNAME"), os.getenv("API_KEY")))
                data = response.json()
                file_content = base64.b64decode(data["content"]).decode("utf-8")

                try: 
                    print("sending", link_titles, "to GPT for processing")
                    classification = str(classifyProposal(link_titles, file_content))
                    print("gpt response", classification)
                except:
                    print("error with asking open ai:", title)

            except:
                print("Error with link:", link_titles)
                with open(f"Obsidian_TC39_Proposals/Proposals/Stage 0 Proposals/{link_titles}.md", "w") as proposals:
                    proposals.write(
                        f"#Stage0Tag\n"
                        f"Classification:\n"
                        f"Title: {title}\n"
                        f"Authors: {authors}\n"
                        f"Champions: {champions}\n"
                        f"Date: {date}\n"
                        f"GitHub Link: {github_link}\n"
                        f"GitHub Note Link: {github_note_link}\n\n"
                        f"# Proposal Description:\n"
                )
                continue

            #-----------------------------------------------------
            with open(f"Obsidian_TC39_Proposals/Proposals/Stage 0 Proposals/{link_titles}.md", "w") as proposals:
                proposals.write(
                    f"#Stage0Tag\n"
                    f"Classification: {classification}\n"
                    f"Title: {title}\n"
                    f"Authors: {authors}\n"
                    f"Champions: {champions}\n"
                    f"Date: {date}\n"
                    f"GitHub Link: {github_link}\n"
                    f"GitHub Note Link: {github_note_link}\n\n"
                    f"# Proposal Description:\n{file_content}"
                )
                
