import requests
import base64

url = f"https://api.github.com/repos/tc39/proposals/contents/finished-proposals.md"

response = requests.get(url)
data = response.json()
file_content = base64.b64decode(data["content"]).decode("utf-8")

first = file_content.index("|")
last = file_content.rindex("|")

print("first", first)
print("last", last)

proposalDetails = file_content[first:last]

text = proposalDetails.splitlines()

for n in text:
    words = n.strip().split("|")
    print(words[1], "\n")
    title = words[1].split("][]")
    print(title)

    


