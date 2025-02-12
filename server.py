#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "mcp",
# ]
# ///

from mcp.server.fastmcp import FastMCP
import datetime
import subprocess
import sys

mcp = FastMCP("Honk TTS")

@mcp.tool()
def say_message(message: str) -> dict:
    """Use the MacOS tts to say the provided message"""
    subprocess.run(["say", message])
    return {'message': message, 'status': 'spoken'}

@mcp.tool()
def getDateTime() -> dict:
    """Get the current date and time"""
    return {'datetime': datetime.datetime.now() }

def main():
    mcp.run()

if __name__ == "__main__":
    main()