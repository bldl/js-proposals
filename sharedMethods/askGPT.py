from openai import OpenAI
import os

def classifyProposal(title, proposalDescription):

    systemPrompt = """
    I am conducting research on proposals for ECMAScript and have exported proposal descriptions from the GitHub repositories for each proposal. 
    
    I am sending you the proposal description and I want you to look at it and classify the type of proposal it is. I want to classify them as API changes, Semantic changes, or Syntactic changes.
    
    ### Change Definitions:
    - **API Change**: Modifies or introduces new built-in functions, objects, or methods in the standard library. These changes do not affect the syntax of the language but add new functionality to existing features.
    - **Semantic Change**: Changes the meaning of the JavaScript code even if the syntax remains the same. These changes can alter the behavior of existing JavaScript programs in subtle or breaking ways. Usually involves modifying execution rules rather than introducing new syntax.
    - **Syntactic Change**: Introduces new syntax or modifies existing syntax rules. Usually involves new keywords, operators, or expressions. These changes often require updates to parsers and affect how JavaScript code is written.
    
    ### CRITICAL: RESPONSE FORMAT ###
    After classifying the proposal, return **ONLY** one of the following strings:
    - [[API Change]]
    - [[Semantic Change]]
    - [[Syntactic Change]]
    
    If multiple classifications apply, return a **space-separated string** like:
    - [[API Change]] [[Syntactic Change]]
    
    DO NOT return any explanations, markdown, or extra text. Just the classification string.
    """


    client = OpenAI(api_key=os.getenv("OPENAI"))

    try:
        completion = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": systemPrompt},
                {"role": "user", "content": proposalDescription}
            ]
        )

        bot_response = completion.choices[0].message.content

        return bot_response

    except:
        print("error with", title)


def stageUpgrade(linkTitle, commitHistory):

    systemPrompt = """
    
    I am conducting research into ECMAScript proposals and I want to look at the timeline of the commits for each proposal.
    
    I have extracted the commit history for each proposal and have filtered it down to commit messages, authors, and dates for when the proposal upgraded stage.

    I am sending you this data and I want you to take a look at the commit history and return to me a list of when the stage upgrade happened in this format:
    
    Stage 1: *insert date*
    Stage 2: *insert date*
    Stage 2.7: *insert date*
    Stage 3: *insert date*
    Stage 4: *insert date*

    Since I will be inserting these dates into a md file, please only inlcude the information I have asked for above.

    The date for stage 1 should be the earliest commit in the history unless explicitly stated.

    If there is no mention of the specific proposal being upgraded, please fill in the date as NA instead. 
    If there is more than one mention of a upgrade for a specific stage, use the earliest date.

    Please and thank you in advance!

    """

    client = OpenAI(api_key=os.getenv("OPENAI"))

    try:
        completion = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": systemPrompt},
                {"role": "user", "content": linkTitle},
                {"role": "user", "content": commitHistory}
            ]
        )

        bot_response = completion.choices[0].message.content
        
        return bot_response

    except:
        print("error with askGPT")