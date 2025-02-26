import ast
import requests
import base64
import os
from dotenv import load_dotenv
import datetime

from sharedMethods.askGPT import classifyProposal, getKeyWords
from sharedMethods.stageUpgrades import getStageUpgrades
from sharedMethods.sharedSendToObsidian import sendToObsidian

sendToObsidian('Stage 1', 'Stage_1')