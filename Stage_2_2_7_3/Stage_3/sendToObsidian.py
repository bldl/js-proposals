import ast
import requests
import base64
import os
from dotenv import load_dotenv
import datetime

from sharedMethods.askGPT import classifyProposal, getKeyWords
from sharedMethods.stageUpgrades import getStageUpgrades

from sharedMethods.sharedSendToObsidian import sendToObsidian

sendToObsidian('Stage 3', 'Stage_2_2_7_3/Stage_3')