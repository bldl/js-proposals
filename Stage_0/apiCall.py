import requests
import base64

url = f"https://api.github.com/repos/tc39/proposals/contents/stage-0-proposals.md"

response = requests.get(url)
data = response.json()
file_content = base64.b64decode(data["content"]).decode("utf-8")

with open("Stage_0/outputMD/apiResponse.md","w") as contents:
    contents.write(file_content)

