import ast

with open("Stage_2_2_7_3/Stage_3/outputMD/apiResults.md", "r") as file:
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

            title = title.strip("[[]]")

            invalid_chars = '\\/*?:"<>|'
            for char in invalid_chars:
                title = title.replace(char, "")

            with open(f"Obsidian_TC39_Proposals/Proposals/Stage 3 Proposals/{title}.md", "w") as proposals:
                proposals.write(
                    f"#Stage3\n"
                    f"Authors: {authors}\n"
                    f"Champions: {champions}\n"
                    f"Date: {date}\n"
                    f"Link Titles: {link_titles}\n"
                    f"GitHub Link: {github_link}\n"
                    f"GitHub Note Link: {github_note_link}\n"
                )
                
