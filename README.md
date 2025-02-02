# tc39_proposals_project

20 credit z-inf project

Student: Kai Waløen (UiB)

Supervisor: Mikhail Barash (UiB)

Examinator: Mikhail Barash (UiB), Anya Helene Bagge (UiB), Yulia Startsev (Mozilla)

JavaScript is amongst the world’s most popular and most used languages. It is a popular choice for web development and is supported by powerful libraries and frameworks such as React, Angular, Vue.js, Next.js and many more. The committee responsible for maintaining and standardizing the JavaScript programming language is Technical Committee 39 (TC39) of the ECMA International. There are 6 TC39 meetings each year in which proposals are made to implement new functionality with the goal foster the evolution of JavaScript, of which University of Bergen was the host of the international TC39 meeting in 2023. In order for a proposal to be implemented into JavaScript, it goes through a rigourous 6 stage process (https://tc39.es/process-document/). Each proposal has one or more author and champion who are responsible for developing and maintaining the proposal.

The goal of this project is in two parts:
Part 1: Map, analyse, and present how the proposals within TC39 affect the JavaScript language and each other. To date there has not been a consise overview of the ongoing and completed proposals within TC39. Information on proposals are available on the TC39 Github (https://github.com/tc39/proposals) but it is not easily accessible and digestible. This data will be presented on a website that will be easily accessible to the members of TC39. 

Part 2: Map and analyse the speed in which proposals are made and implemented. This has implications for the user because new functionalities take time to be adopted by the user. A quick succession of new functionalities could be detramental to the user experience especially if it affects or changes already implemented functionalities.

Proposed workflow:

Part 1: Build proposal map
    1) Collect information on proposals from the TC39 Github repository and sort the data according to proposal stage.

	Proposed Methodology: 
            ▪ Data will be accessed and extracted via Github API using Python

    2) Analyse the description of the proposal and make relations between proposals and language implementations. Information that will be collected include the following:

        a) Title of proposal
        b) Stage of proposal
        c) Date of proposal
        d) Author
        e) Champion
        f) Description of proposal
        g) Related proposals and language implementations

	Proposed Methodology:

            ▪ A chatbot will be built to take in the data that was extracted in the step 1 with a system prompt to extract the information specified above. 
            ▪ Related proposals and language implementations will be analysed using an LLM and manually curated and double checked. 
              
    3) Build a map of relations between the proposals (proposals will be nodes and relations will be edges). Obsidian will be used as a note taking tool due to its linking functionality. 

	Proposed Methodology:
            ▪ Obsidian will be used to keep note of the data to take advantage of its linking functionality
            ▪ Data will the stored in a graph database such as Neo4j.
            ▪ A tool such as CytoScape.js will be used to present the data with Neo4j as an interactive map.

    4) Deploy website to host the frontend and present the interactive CytoScape.js graph database. Alternatively Obsidian publish can be used as a backup plan. A backend will be built and deployed using either Django or FastAPI to support the graph database. A key point of this project is to give the members of TC39 an easily accessible overview of the proposals.

	Proposed Methodology:
            ▪ Next.js will be used and hosted on Vercel.
            ▪ The backend will use Django or FastAPI and hosted on my (Kai) server at home or on an cloud server.
            ▪ Obsidian publish will be used as a backup plan.


Part 2: Analyse rate of change 

The data collected in Part 1 will be used to create a graph to present the rate of change of the JavaScript language per TC39 meeting. The proposals will be arranged per date and presented on an interactive graph. This will be done using a tool such as React Charts. The rate of change will be calculated using derivatives similar to that used in physics (https://en.wikipedia.org/wiki/Fourth,_fifth,_and_sixth_derivatives_of_position). The graph will change and present the data according to what the user clicks on. This will be presented on the same website as the map will be presented.


# How to use:

Extract proposal summaries:

NB:
- Make sure that the proposal folders exist in Obsidian
- Logs will return error messages for incomplete strings which are artifacts of the parsing process. This is expected but check error messages for details.

Create venv:
python -m venv venv

Activate venv:
source venv/bin/activate 

To retrieve updated repositories from Github API:
Run apiCall.py in each stage.

Finished:
`python -m Finished.extractFromApiResponse` then run sendToObsidian.py in /Finished

Inactive:
`python -m Inactive.extractFromApiResponse` then run sendToObsidian.py in /Inactive

Stage0:
`python -m Stage_0.extractFromApiResponse` then run sendToObsidian.py in /Stage_0

Stage1:
`python -m Stage_1.extractFromApiResponse` then run sendToObsidian.py in /Stage_1

For Stage 2, 2.7, and 3:
Run extractAndDelegateFromApiResponse.py

Stage2:
`python -m Stage_2_2_7_3.Stage_2.extractFromApiResponseStage2` then run sendToObsidian.py in /Stage_2_2_7_3/Stage_2

Stage2.7:
`python -m Stage_2_2_7_3.Stage_2_7.extractFromApiResponseStage2_7` then run sendToObsidian.py in /Stage_2_2_7_3/Stage_2_7

Stage3:
`python -m Stage_2_2_7_3.Stage_3.extractFromApiResponseStage3` then run sendToObsidian.py in /Stage_2_2_7_3/Stage_3

Open obsidian file in Obsidian and see the graph!
