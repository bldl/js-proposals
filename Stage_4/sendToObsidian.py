import ast
import requests
import base64
from dotenv import load_dotenv

with open("Stage_4/outputMD/apiResults.md", "r") as file:
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

            #----------api call for readme------------------------
            #githubReadme = f"https://api.github.com/repos/tc39/{github_link}/contents/README.md"
            #response = requests.get(githubReadme, auth=(load_dotenv(USERNAME), load_dotenv(API_KEY)))
            #data = response.json()
            #file_content = base64.b64decode(data["content"]).decode("utf-8")
#
            #print(file_content)

            #-----------------------------------------------------

            with open(f"Obsidian_TC39_Proposals/Proposals/Stage 4 Proposals/{link_titles}.md", "w") as proposals:
                proposals.write(
                    f"#Stage4\n"
                    f"Title: {title}\n"
                    f"Authors: {authors}\n"
                    f"Champions: {champions}\n"
                    f"Date: {date}\n"
                    f"GitHub Link: {github_link}\n"
                    f"GitHub Note Link: {github_note_link}\n"
                )
                
